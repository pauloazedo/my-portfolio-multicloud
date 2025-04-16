// my-portfolio/frontend/next.config.ts

import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  reactStrictMode: true,

  // Dynamically set basePath based on env
  basePath: process.env.NEXT_PUBLIC_BASE_PATH || '',

  async rewrites() {
    return [
      {
        source: '/healthz',
        destination: '/api/healthz',
      },
    ];
  },
};

export default nextConfig;
