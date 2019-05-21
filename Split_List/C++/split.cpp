#include <iostream>

using namespace std;

typedef struct node {
	int data;
	struct node *next;
} linkedList;

linkedList* split (linkedList *&l, int index) {
	linkedList *temp = new linkedList;
	linkedList *init = new linkedList;
	init = l;
	temp = l;
	if (temp == 0) return 0;
	if (temp->data == index) {
		l = temp;
		return 0;
	}
	while (temp->next != 0) {
		if (temp->next->data == index) {
			l = temp->next;
			temp->next = 0;
			return init;
		}
		else
			temp = temp->next;
	}

	l = init;
	return init;
}

int main() {
	linkedList *l = new linkedList;
	linkedList *temp = new linkedList;
	l->data = 0;
	l->next = new linkedList;
	l->next->next = new linkedList;
	l->next->next = 0;                  // 0 -> 4 -> null
	(l->next)->data = 4;
	temp = split(l, 4);
	cout << l->data << endl;
	cout << temp->data << endl;
	return 0;
}
