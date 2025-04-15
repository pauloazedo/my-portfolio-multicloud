// my-portfolio/frontend/next.config.ts

import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  reactStrictMode: true,

  // Enable SWC-based minification for smaller bundles
  swcMinify: true,

  // Rewrite /healthz to the healthcheck API route
  async rewrites() {
    return [
      {
        source: '/healthz',
        destination: '/api/healthz',
      },
    ];
  },

  // You can extend more features here as needed
};

export default nextConfig;
