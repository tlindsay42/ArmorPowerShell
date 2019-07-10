# The Armor Community PowerShell Module

[![Current Version](https://img.shields.io/powershellgallery/v/Armor.svg)](https://www.powershellgallery.com/packages/Armor)
[![Total Downloads](https://img.shields.io/powershellgallery/dt/Armor.svg)](https://www.powershellgallery.com/packages/Armor)

[![Build Status](https://ci.appveyor.com/api/projects/status/x4ik2enxvdc5h0x6/branch/master?svg=true)](https://ci.appveyor.com/project/tlindsay42/ArmorPowerShell/branch/master)
[![Build Status](https://travis-ci.org/tlindsay42/ArmorPowerShell.svg?branch=master)](https://travis-ci.org/tlindsay42/ArmorPowerShell)
[![Coverage Status](https://coveralls.io/repos/github/tlindsay42/ArmorPowerShell/badge.svg?branch=master)](https://coveralls.io/github/tlindsay42/ArmorPowerShell?branch=master)
[![Join the chat at https://gitter.im/ArmorPowerShell/Lobby](https://badges.gitter.im/ArmorPowerShell/Lobby.svg)](https://gitter.im/ArmorPowerShell/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This is an open source, community project that provides a powerful command-line interface for managing and monitoring your **[Armor Complete](https://www.armor.com/armor-complete-secure-hosting/ 'Armor Complete Product Page')** (secure public cloud) and **[Armor Anywhere](https://www.armor.com/armor-anywhere-security/ 'Armor Anywhere Product Page')** (security as a service) environments and accounts via a PowerShell module with cmdlets that interact with the published [RESTful APIs](https://docs.armor.com/display/KBSS/Armor+API+Guide 'Armor API Guide').

Every code push is built using psake on **Windows** and **Ubuntu Linux** via [AppVeyor](https://ci.appveyor.com/project/tlindsay42/ArmorPowerShell/branch/master 'AppVeyor: ArmorPowerShell: Latest Build Console'), as well as on **macOS** and **Ubuntu Linux** via [Travis CI](https://travis-ci.org/tlindsay42/ArmorPowerShell 'Travis CI: ArmorPowerShell: Latest Build Console'), and tested using the [Pester](https://github.com/pester/Pester 'Pester GitHub repo') test and mock framework.

Code coverage scores and reports showing 100% coverage are tracked by [Coveralls](https://coveralls.io/github/tlindsay42/ArmorPowerShell?branch=master 'Coveralls: ArmorPowerShell: Latest Report').

Cmdlet & private function documentation is generated programmatically via platyPS and rigorously tested to ensure accuracy.

Every successful continuous integration build is continuously deployed to the [AppVeyor](https://ci.appveyor.com/project/tlindsay42/ArmorPowerShell/branch/master 'AppVeyor: ArmorPowerShell: Latest Build Console') NuGet project feed as a prerelease version for contributors.

Every successful continuous integration build on the master branch is continuously deployed to the [PowerShell Gallery](https://www.powershellgallery.com/packages/Armor 'PowerShell Gallery') to deliver rigorously tested new features as fast as possible to end users.
