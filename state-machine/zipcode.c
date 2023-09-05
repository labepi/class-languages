#include <stdio.h>
#include <stdlib.h>

struct afd
{
    unsigned int n;
    unsigned int start;
    unsigned int final;
    struct node **transitions;
};

struct node
{
    char symbol;
    unsigned int state;
    struct node *next;
};

struct node *create_node(char c, unsigned int s)
{
    struct node *n = malloc(sizeof(struct node));
    n->symbol = c;
    n->state = s;
    n->next = NULL;
    return n;
}

void node_insert(struct node **l, struct node *n)
{
    n->next = *l;
    *l = n;
}

void destroy_list(struct node *n)
{
    if (n != NULL)
    {
        destroy_list(n->next);
        printf("%p %c %u %p\n", n, n->symbol, n->state, n->next);
        free(n);
    }
}

void destroy_zipcode_afd(struct afd *a)
{
    unsigned int s;

    for (s = 0; s <= 9; s++)
        destroy_list(a->transitions[s]);

    free(a->transitions);
}

void create_zipcode_afd(struct afd *a)
{
    unsigned int s;
    char i;
    a->n = 10;
    a->start = 0;
    a->final = 9;
    a->transitions = malloc(a->n * sizeof(struct node *));

    for (s = 0; s <= 9; s++)
        a->transitions[s] = NULL;

    for (s = 0; s <= 4; s++)
        for (i = '0'; i <= '9'; i++)
            node_insert(&a->transitions[s], create_node(i, s + 1));

    node_insert(&a->transitions[5], create_node('-', 6));

    for (s = 6; s <= 8; s++)
        for (i = '0'; i <= '9'; i++)
            node_insert(&a->transitions[s], create_node(i, s + 1));
}

char match_zipcode(char *string, struct afd *a)
{
    unsigned int i = 0;
    unsigned int s = a->start;
    struct node *n;

    while (string[i] != '\0')
    {
        n = a->transitions[s];

        while (n != NULL)
        {
            if (n->symbol == string[i])
            {
                s = n->state;

                break;
            }

            n = n->next;
        }

        if (n == NULL)
            return 'f';

        i = i + 1;
    }

    if (s == a->final)
        return 's';
    return 'f';
}

int main(int argc, char** argv)
{
    struct afd a;

    create_zipcode_afd(&a);
    printf("%c\n", match_zipcode(argv[1], &a));
    destroy_zipcode_afd(&a);

    return 0;
}
