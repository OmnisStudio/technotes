# Omnis Studio Tech Notes

This repository contains technical notes for Studio 11 or newer.

If you have an interesting topic to cover under a technical note, feel free to submit a pull request!

# How to contribute

---

## Getting started

The technical notes are rendered by mkdocs. In order to get started, you will need Python 3.7.

We target Python 3.7, therefore make sure new packages you add are compatible with Python 3.7!

In order to install the required packages, please use the requirements.txt from the root of this repo:

```
python3 -m pip install -r requirements.txt
```

## Running in dev

Once you have all the required packages, you can use `mkdocs serve` and navigate to **localhost:8000** (note: port may differ) to see a local copy of the website.

## Building for prod

`mkdocs build` can be used to build for production. Executing the command will create a new **site** folder containing all the static files required to run the technical notes website. The contents of the site folder can be simply deployed on a web server in order to serve them to the world.