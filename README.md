# RISC Business: array checks and nested calculations in RISC-V assembly

RISC Business brings two familiar algorithms down to registers, branches, word loads, and stack operations. One program checks whether an integer array is strictly increasing; the other calculates adjusted inventory totals through nested procedure calls.

## 1. Academic context and scope

- **Institution:** Universidade Federal de Minas Gerais (UFMG)
- **Degree:** Ciência da Computação
- **Course:** Organização de Computadores 1
- **Assignment:** Trabalho Prático 1
- **Semester:** 2025-01

`prob1.s` contains the sequence-checking procedure and an embedded verification harness. `prob2.s` contains inventory summation, price adjustment, an additional integer multiplier, and its harness. The work concerns low-level procedure implementation, rather than a general-purpose inventory application or an interactive command-line tool.

Both programs extend course-provided skeletons with procedure implementations inside the designated exercise regions.

## 2. How to run

Use Venus, the 32-bit RISC-V simulator specified by the assignment:

1. Load [prob1.s](prob1.s) in the editor.
2. Switch to the simulator and step through or run the program until `FIM`.
3. Inspect `a0` after each procedure return and `s0` after the harness finishes.
4. Reset the simulator and load [prob2.s](prob2.s) as a separate program; inspect the same registers.

Inputs are embedded in the assembly source. These programs do not read standard input or print a console transcript; their results are inspected through registers.

## 3. Usage example

The supplied arrays in `prob1.s` are:

```asm
vetor1: .word 2, 3, 4
vetor2: .word 1, 5, 4, 6, 8
```

The harness calls `e_crescente` with the array address in `a0` and lengths three and five in `a1`. The procedure returns its Boolean result in `a0`.

The inventory data in `prob2.s` is:

```asm
lista_precos: .word 7, 5, 1
fator_aumento: .word 3
taxa_50: .word 2
```

Its harness checks the complete inventory, an individual price of three, and a tax-function input of two. Each successful comparison increments `s0`.

## 4. Implementation decisions

The sequence procedure compares adjacent word-sized values and advances its pointer by four bytes. A greater-than-or-equal comparison rejects both descending values and equal neighbors, preserving the distinction between strictly increasing and nondecreasing sequences. Lengths zero and one return success before the loop reads adjacent elements.

The inventory program separates summation, adjustment, and multiplication into `soma_estoque`, `ajustar_preco`, and `aplicar_taxa`. Each procedure saves and restores its return address on the stack, allowing calls to nest without losing the caller's continuation. Explicit argument-register updates and array offsets expose responsibilities that higher-level function syntax usually hides.

## 5. Tests and evaluation

Both files contain comparisons against fixed expected values and increment `s0` when those comparisons succeed. They provide inspectable checks for the supplied cases, but do not establish broad edge-case coverage.

### Verified results

Reference output provided in the assignment, expressed as return-register values:

| Program | Procedure and input | Expected `a0` |
| --- | --- | --- |
| `prob1.s` | `e_crescente`: `[2, 3, 4]`, length 3 | `1` |
| `prob1.s` | `e_crescente`: `[1, 5, 4, 6, 8]`, length 5 | `0` |
| `prob2.s` | `soma_estoque`: `[7, 5, 1]`, factors 3 and 2 | `78` |
| `prob2.s` | `ajustar_preco`: value 3, factors 3 and 2 | `18` |
| `prob2.s` | `aplicar_taxa`: value 2, multiplier 2 | `4` |

If every supplied comparison succeeds, the harness finishes with `s0 = 2` for `prob1.s` and `s0 = 3` for `prob2.s`. The inventory reference follows `(7 + 5 + 1) * 3 * 2 = 78`.

## 6. Learning

The work strengthened my understanding of pointer arithmetic, conditional control flow, argument registers, and stack-based return-address preservation. Array boundaries and the order of nested calls were the main implementation concerns.
