"""Offline artifact validation; does not replace an Xcode build or language review."""
import json
import plistlib
import re
from pathlib import Path
import xml.etree.ElementTree as ET

root = Path(__file__).resolve().parent
app = root / 'PesaHindi'
curriculum = (app / 'Curriculum.swift').read_text(encoding='utf-8-sig')
speech = (app / 'HindiSpeechText.swift').read_text(encoding='utf-8-sig')
project = (root / 'PesaHindi.xcodeproj/project.pbxproj').read_text(encoding='utf-8-sig')
days = list(map(int, re.findall(r'makeDay\((\d+),', curriculum)))
assert days == list(range(1, 31)), 'Days must be ordered 1–30'
assert 'minutes: 12' in curriculum

def strings(line):
    return [json.loads(s) for s in re.findall(r'"(?:[^"\\]|\\.)*"', line)]

prompts = [strings(line[line.index('prompt('):]) for line in curriculum.splitlines() if 'prompt("' in line]
roles = [strings(line[line.index('roleplay('):]) for line in curriculum.splitlines() if 'roleplay("' in line]
assert len(prompts) == 120 and len(roles) == 30
for row in prompts:
    assert len(row) == 13 and row[12] in row[8:12], f'Invalid prompt choices: {row[0]}'
    assert all(row[:8]), f'Empty prompt content: {row[0]}'
for row in roles:
    assert len(row) == 14 and row[10] in row[6:10], f'Invalid roleplay choices: {row[0]}'
for group in (prompts, roles):
    assert len({row[0] for row in group}) == len(group), 'Duplicate curriculum ID'

for name, rows in [('prompt', prompts), ('roleplayOpening', roles), ('roleplayReply', roles)]:
    block = re.search(r'static let ' + name + r':.*?= \[(.*?)\n    \]', speech, re.S).group(1)
    pairs = [strings(line) for line in block.splitlines() if '"' in line]
    mapping = dict(pairs)
    assert len(mapping) == len(pairs), f'Duplicate {name} audio IDs'
    assert set(mapping) == {row[0] for row in rows}, f'Incomplete {name} speech coverage'
    assert all(re.search(r'[\u0900-\u097f]', value) for value in mapping.values()), 'Hindi speech text missing'

swift_files = list(app.glob('*.swift'))
for path in swift_files:
    assert f'path = {path.name};' in project, f'Missing project reference: {path.name}'
    assert project.count(f'/* {path.name} in Sources */') == 2, f'Missing build source: {path.name}'
declared = re.findall(r'^\t{2}([A-F0-9]{24})(?: /\*.*?\*/)? = \{', project, re.M)
assert len(declared) == len(set(declared)), 'Duplicate PBX object ID'
assert set(re.findall(r'\b[A-F0-9]{24}\b', project)) <= set(declared), 'Dangling PBX object reference'
for path in root.rglob('*.plist'):
    with path.open('rb') as file:
        plistlib.load(file)
for path in root.rglob('*.xcscheme'):
    ET.parse(path)
for path in app.rglob('Contents.json'):
    data = json.loads(path.read_text(encoding='utf-8-sig'))
    for item in data.get('images', []):
        if 'filename' in item:
            assert (path.parent / item['filename']).is_file()
print(json.dumps({'status': 'ok', 'days': len(days), 'prompts': len(prompts), 'roleplays': len(roles),
                  'hindi_speech_lines': len(prompts) + 2 * len(roles), 'swift_sources': len(swift_files),
                  'xcode_compilation': 'not run; requires macOS/Xcode'}, indent=2))
