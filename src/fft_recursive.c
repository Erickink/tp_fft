#include <stdio.h>
#include <math.h>
#include <string.h>
#include <gem5/m5ops.h>

typedef struct
{
	float real;
	float imag;
} complex_t;

void init_data(complex_t *data, unsigned int k)
{
	for(unsigned int i=0; i < N; i++)
	{
		float theta = (2.0f * M_PI * k * i) / N;
		data[i].real = cosf(theta);
		data[i].imag = sinf(theta);
	}
}

void fft_recursive(complex_t *data, unsigned int n)
{
	if(n == 1)
	{
		return;
	}
	complex_t *even = malloc((n/2) * sizeof(complex_t));
	complex_t *odd = malloc((n/2) * sizeof(complex_t));
	for(unsigned int i=0; i < (n/2); i++)
	{
		even[i] = data[2 * i];
		odd[i] = data[2 * i + 1];
	}
	fft_recursive(even, n/2);
	fft_recursive(odd, n/2);

	for(unsigned int m=0; m < n/2; m++)
	{
		float theta = (-2.0f * M_PI * m) / n;
		complex_t w = {cosf(theta), sinf(theta)};
		complex_t odd_rot = {
			.real = odd[m].real * w.real - odd[m].imag * w.imag,
			.imag = odd[m].real * w.imag + odd[m].imag * w.real
		};

		data[m].real = even[m].real + odd_rot.real;
		data[m].imag = even[m].imag + odd_rot.imag;
		data[m + (n / 2)].real = even[m].real - odd_rot.real;
		data[m + (n / 2)].imag = even[m].imag - odd_rot.imag;
	}
}

void verify(complex_t *data, unsigned int k)
{
	float magnitude = sqrtf(powf(data[k].real, 2) + powf(data[k].imag, 2));
	if(((int) (magnitude + 0.5f)) == N)
	{
		printf("PASSED: ");
	}
	else
	{
		printf("FAILED: ");
	}
	printf("magnitude[k=%d] = %f and N = %d\n", k, magnitude, N);
}

int main(void)
{
	if(N <= 1)
	{
		fprintf(stderr, "ERROR: FFT size N = %d should be > 1\n", N);
		return 1;
	}
	else if((N & (N - 1)) != 0)
	{
		fprintf(stderr, "ERROR: FFT size N = %d should be a power of 2\n", N);
		return 1;
	}
	printf("FFT size [N] = %d\n", N);

	complex_t *input = malloc(N * sizeof(complex_t));
	complex_t *data = malloc(N * sizeof(complex_t));
	unsigned int k = 1;

	init_data(input, k);

	m5_reset_stats(0, 0);
	for(unsigned int i=0; i < ITER; i++)
	{
		memcpy(data, input, N * sizeof(complex_t));
		fft_recursive(data, N);
	}
	m5_exit(0);

	verify(data, k);
	return 0;
}
