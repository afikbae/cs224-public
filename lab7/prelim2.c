/*
Configuration for the code below:

Connect portA to J1 Port of 4 Digit Seven Segment Module
Jumpers of portA are : 5V, pull down ( top one to left, other to right )

Connect portE to J2 Port of 4 Digit Seven Segment Module
Jumpers of portE are : 5V, pull down ( top one to left, other to right )

*/

// patterns so that binary_pattern[x] will display the digit x in the seven segment
unsigned char binary_pattern[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

// 2 variables for calculating fibonacci sequence
unsigned int fib = 1;
unsigned int fib_prev = 0;

// a variable used to count wait times
unsigned int k = 0;

void main() {

	AD1PCFG = 0xFFFF;      	// configure the analog input pins as digital I/O.
	JTAGEN_bit = 0;        	// Disable JTAG

	TRISA = 0x00;  		//portA is output
	TRISE = 0X00;  		//portE is output

	while(1)
	{
		// For every digit there is a 1 ms delay so that to display 4 digits 
		// there are 4 ms of delay.
		// Waiting time is requested to be fibonacci_value * 100 so there must be fibonacci_value * 25 iterations
		// to wait fibonacci_value * 25 * 4 ms = fibonacci_value * 100 ms
		while ( k < fib * 25 ) {
			// Digit 1
			PORTA=binary_pattern[fib / 1000];
			PORTE=0x01; // enable digit 1
			Delay_ms(1);
			
			// Digit 2
			PORTA=binary_pattern[(fib % 1000) / 100];
			PORTE=0x02; // enable digit 2
			Delay_ms(1);

			// Digit 3
			PORTA=binary_pattern[(fib % 100) / 10];
			PORTE=0x04; // enable digit 3
			Delay_ms(1);

			// Digit 4
			PORTA=binary_pattern[fib % 10];
			PORTE=0x08; // enable digit 4
			Delay_ms(1);

			k++;
		}

		// calculating next fibonacci sequence element
		fib = fib + fib_prev;
		// updating previous value
		fib_prev = fib - fib_prev;
	}//while
}//main
