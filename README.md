# Power Quality Analyzer (MATLAB & Simulink)

## 📌 Overview

This project implements a Power Quality (PQ) Analyzer to detect and monitor disturbances in electrical signals. It identifies key power quality issues such as **voltage sag, swell, transient disturbances, and low power factor conditions**.

The project is developed using both **MATLAB (algorithmic implementation)** and **Simulink (real-time simulation model)**.

---

## ⚙️ Features

* Voltage Sag Detection
* Voltage Swell Detection
* Transient Detection
* Power Factor Calculation and Low PF Warning
* Event Counting (number of occurrences of each disturbance)
* Time-stamped event logging
* Real-time visualization using Simulink

---

## 🧠 Working Principle

### MATLAB Implementation

* Input signal is analyzed to compute RMS values and deviations
* Detection logic:

  * **Sag** → Vrms falls below threshold
  * **Swell** → Vrms rises above threshold
  * **Transient** → sudden deviation from nominal waveform
  * **Harmonics** → detected using frequency component analysis
  * **Power Factor** → computed using real and apparent power
* Each detected event is:

  * Logged with timestamp
  * Counted for analysis

---

### Simulink Implementation

* Real-time signal processing using block-based modeling
* Moving RMS used for voltage analysis
* Threshold-based comparators detect:

  * Sag
  * Swell
  * Transients
* Power factor is computed using:

  * Average real power
  * RMS voltage and current
* Low power factor condition triggers a warning signal
* Event counters track number of occurrences

*(Note: Harmonic detection is implemented in MATLAB only.)*

---

## 🛠️ Tools & Technologies

* MATLAB
* Simulink

---

## 📊 Key Parameters

* Nominal Voltage: *(e.g., 230 V)*
* Sag Threshold: *(e.g., < 0.9 pu)*
* Swell Threshold: *(e.g., > 1.1 pu)*
* Transient Threshold: *(set based on deviation)*
* Low Power Factor Threshold: *(e.g., < 0.85)*

---

## 📷 Model Preview

<img width="1518" height="825" alt="image" src="https://github.com/user-attachments/assets/5fabb6de-7940-428b-b9ce-6d4935dbeb63" />

<img width="1431" height="682" alt="image" src="https://github.com/user-attachments/assets/96699849-75c7-4196-8919-93691fd4f202" />


---

## 📈 Outputs

* Detection of sag, swell, and transient events
* Power factor value and low PF alerts
* Event counters for each disturbance
* Console logs with timestamps

---

## 💡 Learning Outcomes

* Power quality analysis techniques
* RMS-based signal processing
* Event detection using threshold logic
* Implementation of power factor calculation
* Comparison of MATLAB vs Simulink approaches

---

## 🔮 Future Improvements

* Add harmonic detection in Simulink
* Implement Total Harmonic Distortion (THD)
* Extend to three-phase systems
* Real-time hardware implementation (IoT/embedded system)

---

Urshita Jaiswal
