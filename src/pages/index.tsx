'use client'

import React, { useEffect, useState } from 'react'
import { motion } from 'framer-motion'
import Certifications from '@/components/Certifications'
import AboutMe from '@/components/AboutMe'
import Experience from '@/components/Experience'
import Tools from '@/components/Tools'
import Education from '@/components/Education'
import Contact from '@/components/Contact'

const bgImages = [
  '/images/background/background1.jpg',
  '/images/background/background2.png',
  '/images/background/background3.jpg',
  '/images/background/background4.jpg',
  '/images/background/background5.jpg',
  '/images/background/background6.jpg',
  '/images/background/background7.jpg',
]

export default function Home() {
  const [bg, setBg] = useState<string>('')
  const [certBg, setCertBg] = useState<string>('')
  const [isMobile, setIsMobile] = useState<boolean>(false)

  // Pick a random background for Home/About Me on mount
  useEffect(() => {
    const randomBg = bgImages[Math.floor(Math.random() * bgImages.length)]
    setBg(randomBg)
  }, [])

  // Pick a random background for Certifications on mount
  useEffect(() => {
    const randomCertBg = bgImages[Math.floor(Math.random() * bgImages.length)]
    setCertBg(randomCertBg)
  }, [])

  // Track if viewport is mobile
  useEffect(() => {
    const mediaQuery = window.matchMedia('(max-width: 767px)')
    setIsMobile(mediaQuery.matches)
    const handler = (e: MediaQueryListEvent) => setIsMobile(e.matches)
    mediaQuery.addEventListener('change', handler)
    return () => {
      mediaQuery.removeEventListener('change', handler)
    }
  }, [])

  return (
    <div className="bg-zinc-900 text-zinc-100 scroll-smooth">
      {isMobile ? (
        <>
          {/* MOBILE: Background spans only the Home section. About Me follows with no background. */}
          <section className="relative" id="home">
            {/* Background container for Home */}
            <div
              className="absolute inset-0 bg-cover bg-center z-0"
              style={{ backgroundImage: `url(${bg})` }}
            >
              <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" />
            </div>

            {/* Foreground content for Home */}
            <div className="relative z-10 flex flex-col justify-center items-center text-center px-4 py-20 pt-32 scroll-mt-16 max-w-sm mx-auto">
              <motion.h2
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.8, delay: 0.3 }}
                className="text-xl font-medium text-white drop-shadow-md"
              >
                Senior Systems and DevOps Engineer / Cloud Architect
              </motion.h2>
              <motion.p
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ duration: 1, delay: 0.6 }}
                className="mt-6 text-sm text-zinc-100 drop-shadow"
              >
                Bridging cloud architecture, DevOps, and automation — delivering secure, 
                scalable, and resilient infrastructure.
              </motion.p>
            </div>
          </section>

          {/* MOBILE: About Me with NO background */}
          <section id="about-me" className="bg-transparent scroll-mt-16 px-4 pb-10 mx-auto w-full">
            <div className="max-w-sm mx-auto">
              <AboutMe />
            </div>
          </section>
        </>
      ) : (
        /* DESKTOP: A single background container spans both Home and About Me */
        <section className="relative" id="home-about">
          {/* Background container for Home and About Me */}
          <div
            className="absolute inset-0 bg-cover bg-center z-0"
            style={{ backgroundImage: `url(${bg})` }}
          >
            <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" />
          </div>

          {/* Foreground content */}
          <div className="relative z-10">
            {/* Home section */}
            <section
              id="home"
              className="flex flex-col justify-center items-center text-center px-4 py-20 pt-32 scroll-mt-16 max-w-2xl mx-auto"
            >
              <motion.h2
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.8, delay: 0.3 }}
                className="text-xl md:text-2xl font-medium text-white drop-shadow-md"
              >
                Senior Systems and DevOps Engineer / Cloud Architect
              </motion.h2>
              <motion.p
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ duration: 1, delay: 0.6 }}
                className="mt-6 text-sm md:text-base text-zinc-100 drop-shadow"
              >
                Bridging cloud architecture, DevOps, and automation — delivering secure, 
                scalable, and resilient infrastructure.
              </motion.p>
            </section>

            {/* About Me section, sharing the same background on desktop */}
            <section
              id="about-me"
              className="bg-transparent scroll-mt-16 px-4 pb-10 mx-auto w-full"
            >
              <div className="max-w-3xl mx-auto">
                <AboutMe />
              </div>
            </section>
          </div>
        </section>
      )}

      {/* Other sections */}
      <Experience />
      <Tools />
      <Education />

      {/* Certifications section with its own random background, AFTER removing the overlay */}
      <section
        id="certifications"
        className="relative bg-cover bg-center"
        style={{ backgroundImage: `url(${certBg})` }}
      >
        {/* <div className=\"absolute inset-0 bg-black/50\"></div>  // Removed this line */}
        <div className="relative z-10 px-4 py-10">
          <Certifications />
        </div>
      </section>

      <Contact />
    </div>
  )
}