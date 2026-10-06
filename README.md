# Araboth (ערבות) — The Unhackable Computing Stack

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Verification](https://img.shields.io/badge/Verification-seL4_%7C_Isabelle_%7C_Lean_4-success.svg)](specs/)
[![Hardware Security](https://img.shields.io/badge/Hardware-CHERI--RISC--V-orange.svg)](hardware/)
[![Usability](https://img.shields.io/badge/Workloads-PyTorch_%7C_STEM_%7C_POSIX-purple.svg)](runtimes/)

> **Araboth (ערבות)**: *A vertically verified, provably secure computing stack designed to remain mathematically and physically unhackable—even when an adversary possesses complete white-box knowledge of every line of source code, binary bit, and silicon microarchitecture schematic.*

Built for professional software engineers, STEM scientists, and AI researchers who demand modern productivity (Python, PyTorch, C/C++, Rust, shells, GPU acceleration) without compromising mathematical security.

---

## 1. Core Philosophy: The Kerckhoffs Standard

Traditional systems rely on obscurity, patch cycles, and probabilistic defenses. **Araboth** strictly implements **Kerckhoffs’s Principle**:

> *The security of the system must reside entirely in unforgeable mathematical capability tokens and cryptographic keys—not in the secrecy of the implementation.*

Even if an attacker audits every gate in the processor, decompiles every kernel binary, and knows every algorithm running on the machine, **the system cannot be exploited** through software logic, memory corruption, or privilege escalation.

```
 ┌────────────────────────────────────────────────────────────────────────┐
 │           High-Level Workstation & AI Research Environment             │
 │  • Shells (Bash, Zsh) & Editors (Neovim, VS Code Server)               │
 │  • STEM & AI Stacks (PyTorch, TensorFlow, Triton, JupyterLab, Polars)  │
 │  • Toolchains & Compilers (Rust, Clang/LLVM, GCC, nvcc, hipcc)         │
 └───────────────────────────────────┬────────────────────────────────────┘
                                     │ Untrusted POSIX / C APIs
 ┌───────────────────────────────────▼────────────────────────────────────┐
 │  Virtualized OS Compartments (CheriBSD / seL4-VMM Linux Guests)       │
 └───────────────────────────────────┬────────────────────────────────────┘
                                     │ Hardware Capabilities / seL4 IPC
 ┌───────────────────────────────────▼────────────────────────────────────┐
 │  Formally Verified Microkernel: seL4 (CHERI-seL4)                      │
 │  • Proven in Isabelle/HOL down to binary (Confidentiality & Integrity) │
 │  • Zero Ambient Authority (Capability-based memory and IPC tokens)     │
 └───────────────────────────────────┬────────────────────────────────────┘
                                     │ Verified Compilation (CompCert)
 ┌───────────────────────────────────▼────────────────────────────────────┐
 │  Silicon: Formally Specified CHERI-RISC-V Microarchitecture             │
 │  • Tagged hardware memory & 128-bit unforgeable fat pointers           │
 │  • Capability IOMMU / Memory Partitioning (PCIe / Tensor Accelerators) │
 └────────────────────────────────────────────────────────────────────────┘
```

---

## 2. The 5-Layer Architectural Stack

### Layer 1: Silicon & Hardware Physical Ground Truth
* **CHERI-RISC-V Microarchitecture:** Implements unforgeable 128-bit tagged capabilities directly in hardware. Out-of-bounds pointer arithmetic and use-after-free bugs are physically trapped by the CPU pipeline at the gate level.
* **Formal ISA Specification:** Modeled and verified via **Sail RISC-V** and **Kami** (Coq) down to register-transfer logic.
* **Physical Unclonable Functions (PUFs):** Cryptographic keys are never stored in vulnerable non-volatile flash; they are derived ephemerally from microscopic silicon variations at power-up.
* **Capability IOMMU:** Hardware-enforced Direct Memory Access (DMA) firewalls prevent discrete GPUs or tensor accelerators from reading privileged system memory.

### Layer 2: Verification Fabric
* **Interactive Theorem Proving:** Mathematical specifications verified in **Isabelle/HOL**, **Coq**, and **Lean 4**.
* **Verified Compilers:** System bootstrap compiled via **CompCert** and **CakeML**, proving that compiled machine code is an exact semantic refinement of the verified source code.

### Layer 3: Microkernel Operating System Core
* **seL4 (CHERI-seL4):** World's first fully machine-checked microkernel. Mathematical proofs guarantee functional correctness, integrity, and confidentiality.
* **Zero Ambient Authority:** No global `root` or superuser privileges exist. Every system interaction requires presenting an explicit, unforgeable capability token.
* **Crash-Isolated Drivers:** Device drivers (NIC, NVMe, USB) run in sandboxed user-space partitions using **seL4 Microkit**. Driver compromises cannot touch the kernel or adjacent tasks.

### Layer 4: Asymmetric Formal Containment
* **CheriBSD (Pure-Capability OS):** Spatial and temporal memory safety across standard BSD command-line utilities.
* **seL4 Virtual Machine Monitor (VMM):** Disposable Linux virtual machines for software development. Exploits inside a guest VM are physically trapped within that partition.

### Layer 5: High-Performance STEM & AI Workspace
* **Complete Toolchain Compatibility:** GCC, Clang/LLVM, Rust, Fortran, and CUDA toolchains.
* **Accelerated AI & Data Science:** Direct PCIe pass-through to GPUs for **PyTorch**, **OpenAI Triton**, **TensorFlow**, and **JupyterLab** through capability-gated IOMMUs.

---

## 3. Why It Remains Unhackable Under Full White-Box Knowledge

| Conventional Attack Vector | Why Monolithic Systems Fail | How UCS Eliminates It |
| :--- | :--- | :--- |
| **Buffer Overflows / ROP** | Shared memory space, untagged pointers | **CHERI Tagged Pointers:** Hardware traps any pointer modification outside bounds. |
| **Privilege Escalation** | Kernel bugs grant global `UID 0` | **Zero Ambient Authority:** No root user exists; access requires exact capability token. |
| **Compiler Backdoors** | GCC/Clang optimize out security checks | **CompCert / CakeML:** Mathematical proof of translation equivalence to machine code. |
| **Malicious AI Packages** | Pip/npm scripts read host credentials | **seL4-VMM Disposable Guest:** Execution isolated to RAM snapshot; zero host disk access. |
| **DMA Peripheral Exploits** | PCIe devices write directly to RAM | **Capability IOMMU:** Accelerators restricted strictly to allocated tensor memory. |

---

## 4. Repository Structure

```text
araboth/
├── docs/
│   ├── Building-an-Unhackable-Computing-Stack.md  # Original comprehensive foundation specification
│   ├── THREAT_MODEL.md                           # Physical limits & side-channel countermeasures
│   └── ROADMAP.md                                # Five-phase implementation roadmap
├── hardware/
│   ├── cheri_riscv_config.yaml                   # CHERI-RISC-V pipeline & capability tag parameters
│   └── iommu_firewall.json                       # Capability-gated DMA firewall descriptors
├── specs/
│   ├── capabilities.lean                         # Lean 4 formalization of capability calculus
│   └── system_composition.camkes                 # seL4 CAmkES/Microkit architecture manifest
├── runtimes/
│   ├── ai_workspace_guest.json                   # seL4-VMM guest container spec for PyTorch/CUDA
│   └── cheri_bsd_compartment.json                # CheriBSD developer compartment manifest
├── scripts/
│   └── verify_stack.sh                           # Self-audit verification harness
├── LICENSE                                       # Apache 2.0
└── README.md
```

---

## 5. Getting Started & Verification

```bash
# Run stack configuration and capability invariant verification
./scripts/verify_stack.sh
```

For full background, research papers, and technical implementation steps, refer to [`docs/Building-an-Unhackable-Computing-Stack.md`](docs/Building-an-Unhackable-Computing-Stack.md).
