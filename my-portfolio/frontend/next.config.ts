// my-portfolio/frontend/next.config.ts

import type { NextConfig } from 'next'

const basePath = process.env.NEXT_PUBLIC_BASE_PATH || ''
const isSubPath = basePath !== ''

const nextConfig: NextConfig = {
  reactStrictMode: true,

  basePath,
  assetPrefix: isSubPath ? basePath : '',

  async rewrites() {
    return [
      {
        source: '/healthz',
        destination: '/api/healthz',
      },
    ]
  },
}

export default nextConfig