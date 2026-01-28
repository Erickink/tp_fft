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
		float theta = (2.0 * M_PI * k * i) / N;
		data[i].real = cosf(theta);
		data[i].imag = sinf(theta);
	}
}

void bit_reverse(complex_t *data)
{
	unsigned int j = 0;
	for(unsigned int i=0; i < N; i++)
	{
		if(i < j)
		{
			complex_t tmp = data[i];
			data[i] = data[j];
			data[j] = tmp;
		}
		unsigned int m = N >> 1;
		while(m >= 1 && j >= m)
		{
			j = j - m;
			m = m >> 1;
		}
		j = j + m;
	}
}

void compute_twiddle(complex_t *twiddle)
{	
	for (unsigned int i=0; i < (N/2); i++)
	{
		float theta = (-2.0f * M_PI * i) / N;
		twiddle[i].real = cosf(theta);
		twiddle[i].imag = sinf(theta);
	}
}

void fft_precompute(complex_t *data, complex_t *twiddle)
{
	bit_reverse(data);

	for(unsigned int m=2; m <= N; m=m<<1)
	{
		unsigned int stride = N / m;
		for(unsigned int i = 0; i < N; i=i+m)
		{
			for(unsigned int j = 0; j < (m/2); j++)
			{
				complex_t w = twiddle[j * stride]; 
				complex_t even = data[i + j];
				complex_t odd = {
					.real = data[i + j + (m / 2)].real * w.real - data[i + j + (m / 2)].imag * w.imag,
					.imag = data[i + j + (m / 2)].real * w.imag + data[i + j + (m / 2)].imag * w.real
				};

				data[i + j].real = even.real + odd.real;
				data[i + j].imag = even.imag + odd.imag;
				data[i + j + (m / 2)].real = even.real - odd.real;
				data[i + j + (m / 2)].imag = even.imag - odd.imag;
			}
		}
	}
}

void verify(complex_t *data, unsigned int k)
{
	float magnitude = sqrtf(powf(data[k].real, 2.0) + powf(data[k].imag, 2.0));
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

	complex_t input[N];
	complex_t data[N];
	complex_t twiddle[N/2];
	unsigned int k = 1;

	init_data(input, k);

	m5_reset_stats(0, 0);
	compute_twiddle(twiddle);
	for(unsigned int i=0; i < ITER; i++)
	{
		memcpy(data, input, N * sizeof(complex_t));
		fft_precompute(data, twiddle);
	}
	m5_dump_stats(0, 0);

	verify(data, k);
	return 0;
}
