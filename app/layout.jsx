import "./globals.css";

export const metadata = {
  title: "Hindi Listening Trainer",
  description: "Audio-first Hindi/Hinglish recognition trainer for Tamil speakers.",
  manifest: "/manifest.webmanifest",
  icons: {
    icon: "/icon.svg",
    apple: "/icon.svg"
  }
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        {children}
      </body>
    </html>
  );
}
