# FPGA VGA Video Display (RGB444)

## Overview

This project implements a real-time FPGA video display system that outputs RGB444 video through a VGA interface. The design generates the required VGA timing signals and displays live video on a computer monitor.

The project was developed entirely in **Verilog** and demonstrates the implementation of a complete FPGA-based video pipeline.

---

## Features

* Real-time RGB444 video output
* VGA interface implementation
* Verilog RTL design
* Synthesizable FPGA implementation

---

## System Architecture

The design is composed of several hardware modules, including:

* OV7670 CAPTURE
* I2C PROTOCOL
* VGA Controller
* Triple Buffer

---

## Technologies

* **Language:** Verilog
* **Target Platform:** FPGA
* **Video Interface:** VGA
* **Color Format:** RGB444

---

## Repository Structure

```text
src/        -> Verilog source files
constraints/ -> FPGA constraint files (.xdc)
sim/        -> Simulation files
docs/       -> Documentation and images
```

---
## Architecture
![Architecture](docs/Architecture.png)

## Demo
![Demo](docs/DEMO.png)

---

## Author

**Omri Nidam**
