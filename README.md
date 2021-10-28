# Neptunes

A powerful native iOS music player application built using SwiftUI and CoreData. Neptunes gives users the ability to seamlessly upload audio files and personalize their music (titles, artwork, etc) to deliver a music playback experience that's *out of this world*.

![App markup of player view](https://imgur.com/wR2dENi)

## Table of contents
* [Introduction](#introduction)
* [Features](#technologies)
* [Setup and Installation](#setup-and-installation)
* [Sources](#sources)

## Introduction
Existing music players on the App Store such as Spotify and Apple Music make it perplexing by design to import and customize your own music. Other applications like SoundCloud are tarted up with advertisments and needlessly complicated to use. Neptunes eliminates this friction by allowing users to simply import and play their music. Users can have autonomy in how their songs, albums, artists, and playlists are organized and decorated with text, artwork, and colors. 

The goal of this project wasn't to provide a backdoor for pirated music. Instead, this application empowers artists to regain control of their music distribution from predatory streaming services. Platforms such as Bandcamp already make it possible to download music files and directly support artists. Also, a lot of my favorite music like Frank Ocean's Nostalgia Ultra or my live concert footage aren't available on streaming services. The artwork and appearance of an album or playlist makes listening to music so much more enjoyable and I wanted to create an easy way to customize my music. Neptunes was inspired to solve this problem of accessibility and give back control to artists and their fans.

## Features
Neptunes provides all the main functionality you'd expect from a typical music player app plus some additional features to *alienate* itself from the rest :)
* Import music files and edit song titles, artist names, album names, publishing information, and other metadata
* Upload your own cover artwork and header artwork images for album, playlist, and artist pages
* Uses machine learning to generate individual matching color palettes based on cover artwork and header artwork — for both light mode and dark mode
* Intuitive playback controls and a curved audio scrubber

Please refer to the [issues](https://github.com/tsaruggan/neptunes/issues) page to see what new features are being implemented!
	
## Setup and Installation
This project is still under currently under construction and is **not available on the App Store** — yet!

If you dare to experiment with the prototype, run the XCode iOS Simulator. You must have XCode 13 and use an iOS 15.0+ compatible device.

## Sources
Neptunes was inspired by and makes use of the following:
* [koher/swift-image](https://github.com/koher/swift-image)
* [davidkrantz/Colorfy](https://github.com/davidkrantz/Colorfy)
* [raywenderlich/swift-algorithm-club](https://github.com/raywenderlich/swift-algorithm-club)