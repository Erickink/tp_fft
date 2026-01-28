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

The benchmark is configured with the following parameters:
- **FFT Size (N):** 256.
- **Iterations (ITER):** 256 loops/iterations of FFT.

**Verification Logic:**

- **Input:** The input data is initialized with $k=1$ and for $n = 0, \dots, N-1$:

$$x[n] = e^{j \frac{2\pi k n}{N}}$$

- **Check:** We only verify if the magnitude of the output data at the index $k=1$ is equal to $N$:

$$|X[k]| = \sqrt{X_{real}[k]^2 + X_{imag}[k]^2} = N$$

## Configuration & Usage

To run the project, you must ensure the GEM5 path is configured correctly.

**Makefile Setup:**
By default, the Makefile uses the environment variable `$WORKSPACE`. If your setup differs, please modify the `GEM5` path location in the `Makefile`:

```makefile
# Change to your path
GEM5_PATH := /your/custom/path/to/gem5
