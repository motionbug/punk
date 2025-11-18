<div align="center">
  <h1>Punked Tart</h1>
  <strong>Pure Packer file management and orchestration</strong>
</div>

## Contents

- [Contents](#contents)
- [Overview](#overview)
- [Requirements](#requirements)
- [Usage](#usage)
  - [Local](#local)
  - [Docker](#docker)
- [License](#license)

## Overview

Punked [Tart](https://tart.run) is a streamlined tool for managing and orchestrating HashiCorp [Packer](https://packer.io/) builds. This project focuses on pure Packer file management, allowing you to define, organize, and execute Packer templates with ease.

## Requirements

- [Yarn](https://classic.yarnpkg.com/en/docs/install) (for local deployment)
- [Docker](https://www.docker.com/get-started) (for production deployment)

## Usage

Getting started with Punked Tart is easy, simply follow the instructions below:

### Local

    $ yarn serve

### Docker

    $ docker build -t punked-tart .
    $ docker run -d -p 8080:8080 punked-tart

## License

[MIT License](LICENSE)
