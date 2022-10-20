#include<iostream>
#include<fstream>
using namespace std;
class Solution {
public:
	int totalNQueens(int n) {
		if (n == 1) return 1;
		int* a = new int[n], count = 0, row=0, column=0;
		bool up = false,con,flag,forup=false;
		for (int i = 0; i < n; i++) a[i] = -1;
		while (!(up && row==0)) {
			con = false;
			if (up) {
				forup = true;
				up = false;
				if(row!=n) a[row] = -1;
				row--;
				int t = a[row] + 1;
				if (t == n) {
					up = true;
					a[row] = -1;
					continue;
				}
			}
			if (row == n) {
				up = true;
				continue;
			}
			int temp;
			if (a[row] == -1) ;
			else column= (temp = a[row] + 1) == n ? -1 : forup?temp:column;//?
			if (forup) {
				forup = false;
			}
			if (column == n) {
				if (!flag) {
				up = true;
				}
				else {
					flag = false;
					row++;
					column = 0;
				}
				continue;
			}
			if (column == -1) {
				up = true;
				column = 0;
				continue;
			}
			flag = true;
			for (int i =0; i < row; i++) {
				if (a[i] == column || abs(row - i) == abs(column - a[i])) { 
					flag = false;
					break; 
				}
			}
			if (row == 0) { 
				a[0] = column; 
				column = 0;
				row++;
				continue;
			}
			if (flag) {
				if (row == n - 1) count++;
				a[row] = column;
				row++;
				column = 0;
				con = true;
				continue;
			}
			if (con) continue;
			column++;
		}
		return count;
	}
};
int main() {
	fstream inFile;
	inFile.open("in.txt");
	if (!inFile) {
		cout << "cannot open in.txt!";
		return 1;
	}
	int num;
	inFile >> num;
	Solution s;
	cout << s.totalNQueens(num);
	return 0;
}