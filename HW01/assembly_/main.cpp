#include<cstdio>
#include<cmath>

extern "C" bool isPrime(int n);
extern "C" void asmMain();

bool isPrime(int number)
{
	int number_upper = (int)sqrt(number);
	int count = 1;
	for (int i = 2; i <= number_upper; i++)
	{
		if ( ( number % i == 0 ) && ( number != i ) )
		{
			count++;
		}
	}
	if (count == 1) 
	{
		return 1;
	}
	return 0;	//	if ( number's factor > 1 ) is not prime
}


int main()
{
	asmMain();
	return 0;
}