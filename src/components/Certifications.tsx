'use client'

import { useState, useEffect, useRef } from 'react'
import { motion } from 'framer-motion'
import { certifications, Certification } from '@/data/certifications'

export default function Certifications() {
  const [showAll, setShowAll] = useState(false)
  const [selected, setSelected] = useState<Certification | null>(null)
  const [isMobile, setIsMobile] = useState<boolean>(false)

  const modalRef = useRef<HTMLDivElement | null>(null)

  // Determine if viewport is mobile
  useEffect(() => {
    const mediaQuery = window.matchMedia('(max-width: 767px)')
    setIsMobile(mediaQuery.matches)
    const handler = (e: MediaQueryListEvent) => setIsMobile(e.matches)
    mediaQuery.addEventListener('change', handler)
    return () => {
      mediaQuery.removeEventListener('change', handler)
    }
  }, [])

  // Decide how many certifications to show based on viewport
  const initialVisibleCount = isMobile ? 5 : 9
  const visibleCerts = showAll ? certifications : certifications.slice(0, initialVisibleCount)

  // ESC key handler
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        setSelected(null)
      }
    }
    document.addEventListener('keydown', handleKeyDown)
    return () => document.removeEventListener('keydown', handleKeyDown)
  }, [])

  // Outside click handler for modal
  const handleOutsideClick = (e: React.MouseEvent<HTMLDivElement>) => {
    if (modalRef.current && !modalRef.current.contains(e.target as Node)) {
      setSelected(null)
    }
  }

  return (
    <section
      id="certifications"
      className="relative py-24 px-6 text-white overflow-hidden"
    >
      {/* 
        A semi-transparent black overlay with a slight blur
        to improve text contrast against the background.
      */}
      <div className="absolute inset-0 bg-black/40 backdrop-blur-sm pointer-events-none" />

      {/* Foreground content */}
      <div className="relative max-w-6xl mx-auto text-center">
        <motion.h2
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="text-3xl md:text-4xl font-bold mb-12 text-blue-400 drop-shadow-lg"
        >
          Certifications
        </motion.h2>

        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
          {visibleCerts.map((cert, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 10 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.4, delay: index * 0.03 }}
              className="bg-white/95 text-zinc-900 rounded-lg p-4 text-center shadow hover:shadow-lg transition cursor-pointer"
              onClick={() => setSelected(cert)}
            >
              <img
                src={cert.badgeUrl}
                alt={`${cert.name} badge`}
                className="w-20 h-20 mx-auto mb-4"
              />
              <h3 className="font-semibold text-sm sm:text-base">{cert.name}</h3>
              <p className="text-gray-600 text-sm">{cert.issuer}</p>
              <p className="text-gray-500 text-sm mt-1">Issued {cert.date}</p>
              <a
                href={cert.credentialUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="text-blue-600 text-sm hover:underline block mt-2"
                onClick={(e) => e.stopPropagation()}
              >
                Show credential
              </a>
            </motion.div>
          ))}
        </div>

        {/* Show 'See all' button only if we haven't revealed everything */}
        {!showAll && certifications.length > initialVisibleCount && (
          <div className="mt-8 text-center">
            <button
              onClick={() => setShowAll(true)}
              className="text-blue-400 hover:underline text-sm font-medium"
            >
              See all {certifications.length} badges
            </button>
          </div>
        )}
      </div>

      {selected && (
        <div
          className="fixed inset-0 z-50 bg-black/80 flex items-center justify-center p-4"
          onClick={handleOutsideClick}
        >
          <div
            ref={modalRef}
            className="bg-white text-center p-6 rounded-lg shadow-lg relative max-w-md w-full"
          >
            <button
              onClick={() => setSelected(null)}
              className="absolute top-2 right-3 text-gray-500 hover:text-black text-xl"
            >
              &times;
            </button>
            <img
              src={selected.badgeUrl}
              alt={selected.name}
              className="w-40 h-40 md:w-52 md:h-52 mx-auto mb-6"
            />
            <h3 className="text-lg font-semibold text-zinc-900">
              {selected.name}
            </h3>
            <p className="text-gray-600 text-sm">{selected.issuer}</p>
            <p className="text-gray-500 text-sm">Issued {selected.date}</p>
            <a
              href={selected.credentialUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="text-blue-600 hover:underline block mt-3 text-sm"
            >
              Show credential
            </a>
          </div>
        </div>
      )}
    </section>
  )
}