# Laboratórios (OAC - 2021.2)
Laboratórios da disciplina de Organização e Arquitetura de Computadores (OAC), ofertada na Universidade de Brasília (UnB) no semestre de 2021.2.

## Descrição
Laboratórios 1, 3 e 4 realizados na disciplina de OAC. As especificações podem ser encontradas na pasta de Especificações, enquanto os relatórios de cada laboratório estão em suas respectivas pastas.

Laboratórios 3 e 4 tiveram foco em montar processadores na ferramenta Deeds, compatíveis com a ISA RV32I.

### Laboratório 1: Mastermind

Teve como objetivo introduzir o estudante às ferramentas utilizadas na disciplina, assim como introduzi-lo na escrita de código Assembly.

A questão principal pede para se implementar o jogo Mastermind em código Assembly. No jogo, é preciso descobrir um código de 4 cores de uma lista de N cores a partir de tentativas e de dicas baseadas nas cores da tentativa.

### Laboratório 3: Processador Uniciclo

Construção de CPU Uniciclo compatível com a ISA RV32I, com as instruções: add,sub, and, or, xor, slt, sltu, lw, sw, addi, andi, ori, xori, slti, sltiu,sll, slli, lui, auipc, beq, bne, bge, bgeu, blt, bltu, jal e jalr

No projeto, foi construída Unidade Lógico Aritmética (ULA), memórias de instruções e de dados, banco de registradores, bem como o caminho de dados completo, com construção de tabela verdade do Bloco de Controle.

### Laboratório 4: Processador Multiciclo

Construção de CPU Multiciclo compatível com a ISA RV32I, com as instruções: add, sub, and, or, xor, slt, sltu, lw, sw, addi, andi, ori, xori, slti, sltiu, sll, slli, lui, auipc, beq, bne, bge, bgeu, blt, bltu, jal e jalr.

Processador feito com base no que já tinha sido construído no laboratório 3, alterando-se o caminho de dados e o bloco de controle para ser uma CPU multiciclo.
