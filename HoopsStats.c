#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//void addNode(char* NAME, int JPG);
//void printFunc();

typedef struct player {
	int jpg;
	//char* name;
	char name[80];
	struct player* next;
} Node;

// char* strip(char* c) {
// 	int n;
// 	for (n = 0; n < strlen(c); n++){
// 		if (c[n+1] == '\n'){
// 		c[n+1] = '\0';
// 	}
// 	return c;
// 	}
// }

Node* root = NULL;
FILE *fr;

void printFunc(){
	Node* current = NULL;
	//current->next = NULL;
	//Node* temp = NULL;
	current = root;
	
	while(current != NULL){
		// for (int i = 0; i < 100; i++){
		// 	if name[i] == 
		// }
		printf("%s %d\n", current->name, current->jpg);
		Node* temp = current;
		current = current->next;
		//free(temp->name);
		free(temp);
	}
	
}


void addNode(char* NAME, int JPG){
	Node* new_player = (Node*) malloc(sizeof(Node));
	// maybe initialize to NULL;
	Node* current = NULL;
	new_player->next = NULL;
	//new_player->name = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	new_player->jpg = JPG;
	//NAME = (char*) malloc(strlen(line)+1);
	strcpy(new_player->name, NAME);

	if (root == NULL){ //add node at the root if root is null
		// new_player->jpg = JPG;
		// strcpy(new_player->name, NAME);
		root = new_player;
		new_player->next = NULL;
		return;
	}



	else if (new_player->jpg < root->jpg){ //add the new node before root
		// new_player->jpg = JPG;
		// strcpy(new_player->name, NAME);
		new_player->next = root;
		root = new_player;
		//printf("%s", root->name);				
		return;
	}
	else{ //sorting part
		current = root;
		while(current->next != NULL){ //go through list
			if (new_player->jpg < current->next->jpg){ //if one wanting to add is less than current
				new_player->next = current->next; //
				current->next = new_player;
				//printf("%s", current->name);				
				return;
			}
			current = current->next;
		}
		if (current->next == NULL){
			current->next = new_player;
			new_player->next = NULL;
			return;
		}

	}

	//printf("%s", root->name);
}

int main(int argc, char* argv[]){

	fr = fopen(argv[1], "rt"); //opens file
	char* name = NULL;
	int ppg = 0;
	int jnumber = 0;
	int count = 0;
	int jpg = 0;
	char line[80];

	while (fgets(line, 80, fr) != NULL){
		//printf("%s\n", line);
		//fgets(line, 100, fr);
		// strtok(name, "\n");
		// strcpy(name, line);

		// fgets(line, 100, fr);
		// sscanf(line, "%d", &jnumber);

		// fgets(line, 100, fr);
		// sscanf(line, "%d", &ppg);

		// jpg = jnumber - ppg;

		// addNode(name, jpg);
		//printf("%d\n", count);

		if (count % 3 == 0){ //name	
			if(strcmp(line, "DONE") == 0){
				break;

			}
			//strtok(line, "_\n");
			name = (char*) malloc(strlen(line)+1);
			strncpy(name, line, strlen(line)-1);
			//strip(name);


			//addNode(name, jpg);
			//printf("%s\n", name);
		}

		else if (count % 3 == 1){ //jnumber
			jnumber = atoi(line);
			//printf("%d\n", jnumber);
		}

		else if (count % 3 == 2){ //ppg
			ppg = atoi(line);
			jpg = jnumber - ppg;
			addNode(name, jpg);
			free(name);
			//printf("%d\n", ppg);
		}
	count++;


	}
	
 	printFunc();
 	

	
	fclose(fr); //close the file prior to exiting the routine



}






