'use client'

import { useEffect, useState, useRef } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import Image from 'next/image'
import { FaLinkedin, FaGithub } from 'react-icons/fa'
import { MdLocationOn, MdCheckCircle } from 'react-icons/md'
import { HiOutlineDocumentText } from 'react-icons/hi'
import { IoClose } from 'react-icons/io5'

export default function AboutMe() {
  const [isOpen, setIsOpen] = useState(false)
  const modalRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const handleKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') setIsOpen(false)
    }
    window.addEventListener('keydown', handleKey)
    return () => window.removeEventListener('keydown', handleKey)
  }, [])

  useEffect(() => {
    const handleClick = (e: MouseEvent) => {
      if (isOpen && modalRef.current && !modalRef.current.contains(e.target as Node)) {
        setIsOpen(false)
      }
    }
    window.addEventListener('mousedown', handleClick)
    return () => window.removeEventListener('mousedown', handleClick)
  }, [isOpen])

  const ProfileCard = (isModal = false) => (
    <div
      ref={isModal ? modalRef : null}
      className={`relative bg-white/5 backdrop-blur-md ${
        isModal ? 'p-10 max-w-xl' : 'p-6 max-w-sm'
      } rounded-xl shadow-md border border-white/10 flex flex-col items-center justify-center text-center w-full`}
    >
      {/* Close Button */}
      {isModal && (
        <button
          className="absolute top-4 right-4 text-white hover:text-red-400 transition"
          onClick={() => setIsOpen(false)}
        >
          <IoClose size={24} />
        </button>
      )}

      <Image
        src="/images/profile.png"
        alt="Paulo Azedo"
        width={isModal ? 150 : 100}
        height={isModal ? 150 : 100}
        className="rounded-full mx-auto mb-4"
        unoptimized
      />
      <h3 className="text-lg font-semibold text-white">Paulo Azedo</h3>
      <p className="text-sm md:text-base text-zinc-400 mb-3">
        Senior Systems Engineer | Solutions Architect
      </p>

      <div className="flex justify-center gap-5 mb-4">
        <div className="relative group">
          <a
            href="https://linkedin.com/in/pauloazedo"
            target="_blank"
            rel="noopener noreferrer"
            className="text-zinc-300 hover:text-blue-500 transition"
          >
            <FaLinkedin size={30} />
          </a>
          <span className="absolute -bottom-6 left-1/2 -translate-x-1/2 text-xs text-white opacity-0 group-hover:opacity-100 transition">
            LinkedIn
          </span>
        </div>
        <div className="relative group">
          <a
            href="https://github.com/pauloazedo"
            target="_blank"
            rel="noopener noreferrer"
            className="text-zinc-300 hover:text-white transition"
          >
            <FaGithub size={30} />
          </a>
          <span className="absolute -bottom-6 left-1/2 -translate-x-1/2 text-xs text-white opacity-0 group-hover:opacity-100 transition">
            GitHub
          </span>
        </div>
      </div>

      <ul className="text-sm md:text-base text-zinc-300 space-y-2">
        <li className="flex items-center gap-2">
          <MdCheckCircle className="text-green-500" />
          Available for work
        </li>
        <li className="flex items-center gap-2">
          <MdLocationOn className="text-red-500" />
          <a
            href="https://maps.app.goo.gl/BrU93FEqgn1GjJDj8"
            target="_blank"
            rel="noopener noreferrer"
            className="hover:underline text-zinc-300"
          >
            Chicago, IL
          </a>
        </li>
        <li className="flex items-center gap-2">
          <HiOutlineDocumentText className="text-zinc-300" />
          <a
            href="/images/PauloAzedo_Resume.pdf"
            target="_blank"
            rel="noopener noreferrer"
            className="hover:underline text-zinc-300"
          >
            Download Resume
          </a>
        </li>
      </ul>
    </div>
  )

  return (
    <section id="about-me" className="relative z-10 px-6 pt-16 pb-20">
      <div className="max-w-6xl mx-auto flex flex-col md:flex-row items-center md:items-start gap-10">
        {/* Card */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="w-full md:w-1/2 cursor-pointer"
          onClick={() => setIsOpen(true)}
        >
          {ProfileCard(false)}
        </motion.div>

        {/* About Me Text */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
          className="text-zinc-300 w-full md:w-1/2 space-y-4"
        >
          <h3 className="text-xl font-semibold text-blue-400">About Me</h3>
          <p className="text-sm leading-relaxed md:text-base">
            With 20+ years of experience in IT infrastructure, cloud architecture, and DevOps practices, I
            thrive on solving complex challenges. My expertise spans AWS, GCP, OCI, and Azure, with a focus
            on automation, cost efficiency, and secure systems at scale.
          </p>
          <p className="text-sm leading-relaxed md:text-base">
            I’m passionate about simplifying systems, reducing operational toil, and enabling business
            innovation through resilient infrastructure. Whether it’s a global cloud migration or tuning a
            production incident response — I lead with curiosity, engineering excellence, and collaboration.
          </p>
        </motion.div>
      </div>

      {/* Modal */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.9 }}
            transition={{ duration: 0.25 }}
            className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 px-4"
          >
            {ProfileCard(true)}
          </motion.div>
        )}
      </AnimatePresence>
    </section>
  )
}