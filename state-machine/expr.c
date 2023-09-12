#include <stdio.h>
#include <stdlib.h>

struct dfa
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
        free(n);
    }
}

void destroy_dfa(struct dfa *a)
{
    unsigned int s;

    for (s = 0; s < a->n; s++)
        destroy_list(a->transitions[s]);

    free(a->transitions);
}

void create_expr_dfa(struct dfa *a)
{
    unsigned int s;
    char c;
    a->n = 3;
    a->start = 0;
    a->final = 1;
    a->transitions = malloc(a->n * sizeof(struct node *));

    /*
     * initializing empty lists
     */
    for (s = 0; s < a->n; s++)
        a->transitions[s] = NULL;

    for (c = '0'; c <= '9'; c++)
        node_insert(&a->transitions[0], create_node(c, 1));

    for (c = '0'; c <= '9'; c++)
        node_insert(&a->transitions[1], create_node(c, 1));

    node_insert(&a->transitions[1], create_node('-', 2));
    node_insert(&a->transitions[1], create_node('+', 2));
    node_insert(&a->transitions[1], create_node('/', 2));
    node_insert(&a->transitions[1], create_node('*', 2));

    for (c = '0'; c <= '9'; c++)
        node_insert(&a->transitions[2], create_node(c, 1));
}

char match(char *string, struct dfa *a)
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
    struct dfa a;

    create_expr_dfa(&a);
    printf("%c\n", match(argv[1], &a));
    destroy_dfa(&a);

    return 0;
}
