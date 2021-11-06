---
title: "Setting Up My Website"
date: 2021-11-05T17:50:41-04:00
draft: false
categories: ["AWS", "Web"]
toc:
  auto: false
---

I recently decided to set up a personal website to showcase some of the projects I've been working on, and get a better hands-on understanding of static content hosting.

In this post I'll walk through how I got the site set up, what technologies are being used, and some of the issues I ran into.

## Tech Stack

I've never been much of a front-end developer, so finding a static site generator like [hugo](https://github.com/gohugoio/hugo) was a big relief. I decided to host the content myself on AWS as I'm very familiar with that ecosystem, so it was a nice balence of new-and-comfortable.

Hugo generates a bunch of files which comprise the entire website (indexes, html pages, css style sheets, etc), meaning the only thing necessary from a web server is to serve these static files - there's no need for server-side processing. This opens up the option for a very low-cost, low-maintenance hosting solution like AWS S3 static website hosting.

By uploading all the static files that Hugo geneartes to an S3 bucket (something Hugo has native support for), we can allow AWS to serve these files from their infrastructure while only paying for the long-term data storage, and per-request fees. For a small personal website, this adds up to about $0.00 / month