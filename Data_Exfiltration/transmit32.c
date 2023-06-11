/*Header files*/
#include<emmintrin.h>
#include<xmmintrin.h>
#include<stdio.h>
#include<time.h>
#include<math.h>
#include<windows.h>

/*Macros*/
#define buffer_size 4096														/*Buffer size in bytes*/

/*Global variables*/
__m128 XMM_0;																	/*Reference to an XMM CPU register*/

																				/*transmit32 function transmits a 32-bit number "data" as follows:
																				1. For each bit of the data, 128-bit status of an XMM register is transferred to a buffer in main memory (RAM) using multi-channel path.
																				2. The status is transferred repeatedly to fill the buffer of size "buffer_size" and for a time "tx_time".
																				3. The function returns the pointer to buffer.
																				4. The function also prints the status of buffer after each bit transmission*/

float* transmit32(int data, int info)											/*info defines how many LSBs should be transferred*/
{
	/*Declaration of variables*/
	float *buffer, *buffer_ptr;													/*Pointers to the buffer stored in main memory*/
	double tx_time = 0.5;															/*Transmit time for each bit in seconds*/
	DWORD tx_time_ms = (DWORD)(int)(tx_time * 1000);							/*Sleeping time when a bit is zero*/
	int i, j, mask, bit;														/*i, j=Loop variable, mask=Used to extract a bit from data, bit=Result of masking operation*/
	clock_t start_time;															/*Stores the start_time of the transmission*/
	double elapsed_time = 0;

	/*Memory allocation and initialization part*/
	buffer = _aligned_malloc(buffer_size, 16);									/*16-bytes aligned memory allocation for the buffer*/
	for (i = 0; i < buffer_size / 4; i++)
	{
		buffer[i] = 1;
	}
	/*Printing the buffer content*/
	printf("The buffer content after initialization is: \n[");
	for (i = 0; i < (buffer_size / 4) - 2; i++)
	{
		printf("%-4.1f\t", *(buffer + i));
	}
	printf("%-4.1f]\n", *(buffer + (buffer_size / 4) - 1));

	for (j = 0; j < info; j++)													/*Loop for each bit transmission*/
	{
		mask = (int)pow(2, j);													/*ith LSB extraction from data*/
		bit = data & mask;
		bit = bit >> j;

		/*Transmission part*/
		if (bit)																/*If bit is 1, note the current time*/
		{
			elapsed_time = 0;
			start_time = clock();
			while (tx_time > elapsed_time)										/*While the transmission duration is less than tx_time*/
			{
				buffer_ptr = buffer;
				for (i = 0; i < buffer_size / 4; i = i + 4)						/*Repeatedly send the register status to the buffer until the buffer is filled*/
				{
					buffer_ptr = buffer + i;
					_mm_stream_ps(buffer_ptr, XMM_0);

				}
				elapsed_time = (double)(clock() - start_time) / CLOCKS_PER_SEC;
			}
			/*Printing the buffer content*/
			printf("The buffer content after transferring LSB no. %d (T=%f sec): \n[", j, elapsed_time);
			for (i = 0; i < (buffer_size / 4) - 2; i++)
			{
				printf("%-4.1f\t", *(buffer + i));
			}
			printf("%-4.1f]\n", *(buffer + (buffer_size / 4) - 1));
		}

		/*Sleeping part*/
		else																	/*Else if bit is 0, sleep for the time tx_time*/
		{
			start_time = clock();
			Sleep(tx_time_ms);
			elapsed_time = (double)(clock() - start_time) / CLOCKS_PER_SEC;
			for (i = 0; i < buffer_size / 4; i++)								/*Introduced for testing purpose*/
			{
				buffer[i] = 0;
			}
			/*printing the buffer content*/
			printf("The buffer content after transferring LSB no. %d (T=%f sec): \n[", j, elapsed_time);
			for (i = 0; i < (buffer_size / 4) - 2; i++)
			{
				printf("%-4.1f\t", *(buffer + i));
			}
			printf("%-4.1f]\n", *(buffer + (buffer_size / 4) - 1));
		}
	}
	return buffer;																/*Return the pointer to the buffer*/
}

/*Main function does the following tasks:
1. First fills the register XMM0 with the array "fill", the contents before and after filling are printed.
2. The data to be transmitted is taken as input along with the no. of bits to be transmitted.
3. Then the transmission of data is performed by the transmit32() function.
4. Finally, the status of buffer stored in main memory is printed.*/

void main()
{
	/*Declaration of variables*/
	int i, data, info;									/*Loop variable, rest of variables as mentioned above*/
	float fill[4], *buffer;								/*Array declaration to fill the XMM0 register and pointer to buffer*/

														/*Filling of register part*/
	for (i = 0; i < 4; i++)								/*Initialization of array*/
	{
		fill[i] = (float)((i + 1) * 10);
	}
	printf("The contents of register XMM_0 before filling: [%4.1f, %4.1f, %4.1f, %4.1f]\n", XMM_0.m128_f32[0], XMM_0.m128_f32[1], XMM_0.m128_f32[2], XMM_0.m128_f32[3]);
	getchar();
	XMM_0 = _mm_loadu_ps(fill);							/*Sending the array to register XMM0*/
	printf("The contents of register XMM_0 after filling: [%4.1f, %4.1f, %4.1f, %4.1f]\n", XMM_0.m128_f32[0], XMM_0.m128_f32[1], XMM_0.m128_f32[2], XMM_0.m128_f32[3]);
	getchar();

	/*Transmission of data part*/
	printf("Enter the data (integer) to be transmitted:");
	scanf_s("%x", &data);
	printf("\n");
	printf("Enter no. of LSBs of data to be transmitted:");
	scanf_s("%d", &info);
	printf("\n");
	buffer = transmit32(data, info);					/*Function calling*/

	return;
}
