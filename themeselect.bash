#!/bin/bash
function next-theme() {
    Navbar="${1}"
    ThemeToggle="${2}"

    if [[ $Navbar == "" ]]; then
        Navbar="Navbar"
    fi
    if [[ $ThemeToggle == "" ]]; then
        ThemeToggle="ThemeToggle"
    fi

    red="\033[0;31m"
    yellow="\033[0;33m"
    green="\033[0;32m"
    white="\033[0;37m"
    error="ERROR!"
    warning="WARNING!"
    success="SUCCESS!"

    if [ -f "./package.json" ]; then
        npm install @emotion/react @emotion/styled
        echo -e "${green}${success} Installed ${white}@emotion/react ${green}and ${white}@emotion/styled"
    else
        echo -e "${red}${error} Wrong directory ! (no package.json file detected)"
        return
    fi
    if [ ! -d "./components" ] && [ ! -d "./Components" ]; then
        mkdir components
        echo -e "${green}${success} Created ${white}components ${green}folder"
    fi
    if [ -d "./components" ]; then
        cd components
    elif [ -d "./Components" ]; then
        cd Components
    fi

    if [ -f "./${Navbar}.js" ]; then
        echo -e "${red}${error} file ${white}${Navbar} ${red}already exists"
        cd ..
        return
    fi
    if [ -f "./${ThemeToggle}.js" ]; then
        echo -e "${red}${error} file ${white}${ThemeToggle} ${red}already exists"
        cd ..
        return
    fi
    echo -e "import dynamic from 'next/dynamic';\n\nconst ThemeToggle = dynamic(() => import('../components/${ThemeToggle}'), {\n    ssr: false,\n  });\n\nconst Navbar = () => {\n    return(\n        <header>\n            <nav>\n            </nav>\n            <ThemeToggle/>\n        </header>\n    )\n}\n\nexport default Navbar" > ${Navbar}.js    
    echo -e "${green}${success} Added ${white}${Navbar} ${green}file"
    echo -e "import styled from '@emotion/styled';\nimport { useEffect, useState } from 'react';\n\nconst ToggleButton = styled.button\`\n  --toggle-width: 80px;\n  --toggle-height: 38px;\n  --toggle-padding: 4px;\n  position: relative;\n  display: flex;\n  align-items: center;\n  justify-content: space-around;\n  font-size: 1.5rem;\n  line-height: 1;\n  width: var(--toggle-width);\n  height: var(--toggle-height);\n  padding: var(--toggle-padding);\n  border: 0;\n  border-radius: calc(var(--toggle-width) / 2);\n  cursor: pointer;\n  background: var(--color-bg-toggle);\n  transition: background 0.25s ease-in-out;\n  transition: background 0.25s ease-in-out, box-shadow 0.25s ease-in-out;\n  &:focus {\n    outline-offset: 5px;\n  }\n  &:focus:not(:focus-visible) {\n  outline: none;\n  }\n  &:hover {\n    box-shadow: 0 0 5px 2px var(--color-bg-toggle);\n  },\n\`;\n\nconst ToggleThumb = styled.span\`\n  position: absolute;\n  top: var(--toggle-padding);\n  left: var(--toggle-padding);\n  width: calc(var(--toggle-height) - (var(--toggle-padding) * 2));\n  height: calc(var(--toggle-height) - (var(--toggle-padding) * 2));\n  border-radius: 50%;\n  background: white;\n  transition: transform 0.25s ease-in-out;\n  transform: \${(p) =>\n  p.activeTheme === 'dark'\n      ? 'translate3d(calc(var(--toggle-width) - var(--toggle-height)), 0, 0)'\n  : 'none'};\n\`;\n\nconst ThemeToggle = () => {\n  const [activeTheme, setActiveTheme] = useState(document.body.dataset.theme);\n  const inactiveTheme = activeTheme === 'light' ? 'dark' : 'light';\n\n  useEffect(() => {\n    const savedTheme = window.localStorage.getItem('theme');\n    savedTheme && setActiveTheme(savedTheme);\n  }, []);\n\n  useEffect(() => {\n    document.body.dataset.theme = activeTheme;\n    window.localStorage.setItem('theme', activeTheme);\n  }, [activeTheme])\n\n  return (\n    <ToggleButton aria-label={\`Change to \${inactiveTheme} mode\`} title={\`Change to \${inactiveTheme} mode\`} type='button' onClick = {() => setActiveTheme(inactiveTheme)}>\n      <ToggleThumb activeTheme = {activeTheme}/>\n      <span aria-hidden={true}>🌙</span>\n      <span aria-hidden={true}>☀️</span>\n    </ToggleButton>\n  );\n};\n\nexport default ThemeToggle;" > ${ThemeToggle}.js
    echo -e "${green}${success} Added ${white}${ThemeToggle} ${green}file"
    cd ..
    cd pages
    if [ -f "_document.js" ]; then
        mv _document.js \(OLD\)_document.js
        echo -e "${yellow}${warning} file ${white}_document.js ${yellow} already exists"
        echo -e "${yellow}${warning} file ${white}_document.js ${yellow} got renamed to ${white}(OLD)_document.js"
    fi
    echo -e "import Document, { Html, Head, Main, NextScript } from 'next/document';\n\nclass MyDocument extends Document {\n  static async getInitialProps(ctx) {\n    const initialProps = await Document.getInitialProps(ctx);\n    return { ...initialProps };\n  }\n\n  render() {\n    const setInitialTheme = \`\n    function getUserPreference() {\n      if(window.localStorage.getItem('theme')) {\n        return window.localStorage.getItem('theme')\n      }\n      return window.matchMedia('(prefers-color-scheme: dark)').matches\n                ? 'dark'\n                : 'light'\n    }\n    document.body.dataset.theme = getUserPreference();\n  \`;\n    return (\n      <Html>\n        <Head />\n        <body>\n            <script dangerouslySetInnerHTML={{ __html: setInitialTheme }} />\n            <Main />\n            <NextScript />\n        </body>\n      </Html>\n    );\n  }\n}\n\nexport default MyDocument;" > _document.js
    echo -e "${green}${success} Created ${white}_document.js ${green} file"
    cd ..
    if [ ! -d "./styles" ]; then
        cho -e "${red}${error} Folder ${white}styles ${red} does not exist"
        cd ..
        return
    fi
    cd ./styles
    echo -e "body[data-theme='light']{\n  --color-text-primary: #27201a;\n  --color-text-secondary: #076963;\n  --color-bg-primary: #fff;\n  --color-bg-toggle: #1e90ff;\n}\n\nbody[data-theme='dark'] {\n  --color-text-primary: #e3e3e3;\n  --color-text-secondary: #ff6b00;\n  --color-bg-primary: #15232d;\n  --color-bg-toggle: #a9a9a9;\n}\n\nbody {\n  background: var(--color-bg-primary);\n  color: var(--color-text-primary);\n  font-family: sans-serif;\n  transition: background 0.25s ease-in-out;\n}" >> globals.css
    echo -e "${green}${success} Added light and dark data-theme in file ${white}globals.css"
    cd ..
    echo "DONE"
}