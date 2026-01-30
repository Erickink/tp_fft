# TP: Fast Fourier Transform (FFT)

This repository contains three types of FFT using complex float32 data types.

## Algorithms

1. **FFT Recursive**
   - The original "textbook" implementation.
   - Simplest to understand but the slowest and most ressource-intensive due to recursion overhead.

2. **FFT Iterative**
   - An optimized, non-recursive version.
   - Uses the **Bit-Reversal Permutation** algorithm to reorder (shuffle) samples.

3. **FFT Precompute**
   - Same as FFT Iterative.
   - Pre-computes **twiddle factors** (sine and cosine values) to avoid expensive trigonometric calculations inside the main loop.

## Parameters & Verification

The simulation is configured with the following parameters:
- **FFT Size (N):** 256 samples.
- **Iterations (ITER):** 256 loops/iterations of FFT.

**Verification Logic:**

- **Input:** The input data is initialized with $k=1$ and for $n = 0, \dots, N-1$:

$$x[n] = e^{j \frac{2\pi k n}{N}}$$

- **Check:** We only verify if the magnitude of the output data at the index $k=1$ is equal to $N$:

$$|X[k]| = \sqrt{X_{real}[k]^2 + X_{imag}[k]^2} = N$$

## Configuration & Usage

### 1. GEM5 Setup

To run the project, you must ensure the GEM5 path is configured correctly.

**Makefile Setup:**

By default, the Makefile uses the environment variable `$WORKSPACE`. If your setup differs, please modify the GEM5 path location in the Makefile:

```makefile
# Change to your path
GEM5_PATH := /your/custom/path/to/gem5
```

### 2. Available Commands

You can view all available commands by simply running:

```bash
make help
```

### 3. Execution Flow

To run the simulation, follow these steps in order:

* **Step 1: Compile**

Build all three C codes into RISC-V binaries. You can override the default values of `N` and `ITER`:

```bash
make compile_all
```

* **Step 2: Simulate**

Run the compiled binaries through the GEM5 simulator:
```bash
make simulate_all
```

* **Step 3: View Results**

Check the performance metrics for each specific implementation:

```bash
make result_fft_recursive
make result_fft_iterative
make result_fft_precompute
```

### 4. Cleaning Up

To remove build artifacts and generated files:

```bash
make clean
```
