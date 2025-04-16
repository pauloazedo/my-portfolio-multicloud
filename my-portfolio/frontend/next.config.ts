// my-portfolio/frontend/next.config.ts

import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  reactStrictMode: true,

  // Rewrite /healthz to the healthcheck API route
  async rewrites() {
    return [
      {
        source: '/healthz',
        destination: '/api/healthz',
      },
    ];
  },

  // Add more config options here if needed
};

export default nextConfig;
