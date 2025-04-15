// my-portfolio/frontend/src/components/Footer.tsx

const Footer = () => {
  const version = process.env.NEXT_PUBLIC_APP_VERSION || 'v0.0.0';
  const cloud = process.env.NEXT_PUBLIC_CLOUD_PROVIDER || 'unknown';

  return (
    <footer className="w-full text-center py-4 border-t border-blue-800 bg-zinc-900 text-zinc-400 text-sm">
      © 2025 Paulo Azedo. All rights reserved {version} running on {cloud}.
    </footer>
  );
};

export default Footer;