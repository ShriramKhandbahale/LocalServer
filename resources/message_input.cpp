#include <iostream>
#include <bits/stdc++.h>

using namespace std;

#define USER_INPUT 1000

int main()
{
    char CUSTOM_MESSAGE[USER_INPUT];

    cout << "Enter a custom message to display on the page: ";
    cin.getline(CUSTOM_MESSAGE, USER_INPUT);

    FILE *ptr = fopen(".message.txt","w");
    fprintf(ptr, "%s", CUSTOM_MESSAGE);

    fclose(ptr);
}
