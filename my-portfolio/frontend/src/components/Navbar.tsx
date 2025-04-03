'use client'

import Image from 'next/image'
import { useState, useRef, useEffect } from 'react'

const Navbar = () => {
  const [isOpen, setIsOpen] = useState(false)
  const menuRef = useRef<HTMLDivElement>(null)

  const navItems = [
    { name: 'Home', href: '#home' },
    { name: 'About Me', href: '#about-me' },
    { name: 'Experience', href: '#experience' },
    { name: 'Tools', href: '#tools' },
    { name: 'Education', href: '#education' },
    { name: 'Certifications', href: '#certifications' },
    { name: 'Contact', href: '#contact' },
  ]

  const handleNavClick = (e: React.MouseEvent<HTMLAnchorElement>, href: string) => {
    e.preventDefault()
    setIsOpen(false)

    // Ensure the element exists in DOM before scroll
    setTimeout(() => {
      const target = document.querySelector(href)
      if (target) {
        target.scrollIntoView({ behavior: 'smooth' })
      }
    }, 0)
  }

  // Close mobile menu when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (isOpen && menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setIsOpen(false)
      }
    }

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside)
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
    }
  }, [isOpen])

  return (
    <nav className="fixed top-0 w-full z-50 backdrop-blur-sm bg-zinc-900/80 border-b border-blue-800 text-white scroll-smooth">
      <div className="relative max-w-6xl mx-auto px-6 py-4 flex items-center justify-center md:justify-between">

        {/* Hamburger - left on mobile */}
        <button
          className="md:hidden absolute left-6 text-blue-300 text-2xl focus:outline-none"
          onClick={() => setIsOpen(!isOpen)}
          aria-label="Toggle menu"
        >
          ☰
        </button>

        {/* Centered Logo */}
        <a
          href="#home"
          className="flex items-center space-x-2"
          onClick={(e) => handleNavClick(e, '#home')}
        >
          <Image
            src="/images/logo.png"
            alt="Logo"
            width={120}
            height={40}
            priority
            style={{ width: 'auto', height: 'auto' }}
            className="h-10 w-auto"
          />
        </a>

        {/* Desktop Navigation */}
        <ul className="hidden md:flex space-x-6 text-sm font-medium">
          {navItems.map(({ name, href }) => (
            <li key={name}>
              <a
                href={href}
                onClick={(e) => handleNavClick(e, href)}
                className="hover:text-blue-300 transition duration-200 ease-in-out"
              >
                {name}
              </a>
            </li>
          ))}
        </ul>
      </div>

      {/* Mobile Navigation */}
      {isOpen && (
        <div ref={menuRef} className="md:hidden bg-zinc-900/95 border-t border-blue-800 px-6 py-4">
          <ul className="flex flex-col space-y-4 text-sm font-medium">
            {navItems.map(({ name, href }) => (
              <li key={name}>
                <a
                  href={href}
                  onClick={(e) => handleNavClick(e, href)}
                  className="hover:text-blue-300 transition duration-200 ease-in-out"
                >
                  {name}
                </a>
              </li>
            ))}
          </ul>
        </div>
      )}
    </nav>
  )
}

export default Navbar