CP'26 Paper #74 Reviews and Comments
===========================================================================
Paper #74 Table Constraints for Integer Programming


Review #74A
===========================================================================

Overall merit
-------------
3. Weak accept

Paper summary
-------------
This paper studies how to handle table constraints in ILP, through several eager encodings, lazy cut generation, and a hybrid combination of both.

Comments for authors (including questions for rebuttal)
-------------------------------------------------------
This article is a dedicated publication on table constraints in ILP. I think this is a good initiative because such constraints are useful in many contexts, such as assignment or configuration problems. The study compares tuple-based, Booleanized, MDD-based, lazy, and hybrid approaches, and the results provide informative comparison points. The hybrid strategy appears particularly effective.

The paper cites relevant prior work, in particular Refalo (CP 2000), and Belov et al (CP 2016). Yet closely related work seems to be missing from the discussion, especially Petit, "On Constraint Linear Decompositions Using Mathematical Variables" (ICTAI 2017), and Claus et al., "Arc-consistency with linear programming reduced costs (applied to stable set in chordal graphs)" (Artificial Intelligence, 2025). This matters concretely for Section 3. The Booleanized encoding of Section 3.2 is based on the standard variable-value Boolean representation. Section 3.2 should therefore not be presented as a modelling contribution in itself. ICTAI'17 article already discusses table formulations built on top of this decomposition, including negative tables and table reification. The contribution of the paper lies in the MDD formulation and comparison of encodings, as well as their combination of Bool/MDD formulations with cut generation and hybridization.

The experimental setting makes sense: Section 5 uses Gurobi as the ILP solver, with CPMpy to load and linearize the XCSP3 instances and to implement the encodings and cut generators. Modern MIP solvers such as Gurobi already perform strong presolve, reformulations, and generic cut generation on Boolean linear models. This is important for interpreting the results: the performance of the Booleanized and hybrid formulations may come not only from the table encoding itself, but also from how well the encoding exposes structure to Gurobi’s internal machinery. This is not a weakness of the experiments but the paper should discuss this interaction more clearly, for example by specifying which Gurobi parameters were used. 

However, a limitation of the experimental analysis is that the characterization of when each method should be preferred is mostly based on table size measured as the number of rows/allowed tuples. In Section 5.3, Figure 2 uses the median number of rows per instance, and the Hybrid variants are selected using row thresholds of 1000, 2000, and 3000. This is useful, but it does not capture the structural difficulty of the table constraints. Arity, domain sizes, tuple density or sparsity, number of tables, variable sharing, and the strength of the resulting LP/MIP relaxation may also affect whether an eager encoding, lazy cuts, or the hybrid approach is preferable. The conclusion itself mentions sparsity as a possible factor for future work, which suggests that the current experimental characterization ignores this aspect.

The restriction to positive tables also deserves clarification. If negative tables can be handled in essentially the same way, this should be stated explicitly. Otherwise, the limitation should be discussed. The same applies to reification of table constraints, which is central in configuration problems. I think the experiments could easily be extended to this setting, which, together with a more accurate presentation of the state of the art, would make the paper the most up-to-date reference on the topic.






Candidate for best paper
------------------------
1. No



Review #74B
===========================================================================

Overall merit
-------------
4. Accept

Paper summary
-------------
The paper is concerned with encoding of table constraints for
Integer Linear Programming solvers. two encoding methods are proposed: linear encoding, and lazy cut generation approach.
An experimental evaluation follows, showing that the methods proposed in the paper outperform existing methods.

Comments for authors (including questions for rebuttal)
-------------------------------------------------------
The paper is clearly written and the methods are adequately  detailed. The experimental evaluation is convincing, and the benchmarks consist of all instances from the CSP and COP tracks of XCSP3’22–25 competition (180 CSP and 247 COP instances).
The overall results show that the two proposed approaches perform better than existing methods. It is interesting, but not surprising, that an hybrid method, using the eager of the lazy encodings depending on the number of rows of the table, is the overall winner and provide the best results in the proposed approach.

Candidate for best paper
------------------------
1. No



Review #74C
===========================================================================

Overall merit
-------------
3. Weak accept

Paper summary
-------------
This paper investigates various integer linear programming (ILP)
formulations for positive table constraints, aimed at improving the
performance of ILP solvers for solving CSPs.

The authors first review three existing linear formulations:

    - A standard integer formulation that introduces a binary variable
      for every tuple in the table to indicate whether the tuple is
      active, i.e. selected in the solution.

    - A Boolean formulation where a binary variable is created for
      every possible value instantiation.

    - An MDD-based flow formulation (introduced in [6]), where a
      Multivalued Decision Diagram (MDD) represents the table as a
      flow network: an active tuple corresponds to a flow of value
      exactly 1 traversing the corresponding nodes from the root to
      the sink.

The primary algorithmic contribution lies in new cut generation
algorithms applied to the Boolean formulation. These cuts are
generated when the solver encounters either an assignment that
violates a table constraint (Section 4.1) or a relaxed fractional LP
solution (Section 4.2). The authors propose greedy heuristics for
rapid cut generation and a "lifting" procedure (Section 4.3) to
strengthen these cuts. Finally, a hybrid approach is introduced, which
triggers cut generation only when the table size exceeds a specific
threshold.

The approach was evaluated on a large suite of instances from the 2025
CSP and COP tracks of the XCSP'22-25 competition. Key findings
include:

    - On 180 CSP instances: The hybrid approach (threshold = 2000)
      solved 80 instances within 10 minutes, slightly outperforming
      the "min-domain" MDD-DOM variant (76 solved). The standard integer
      formulation performed significantly worse (e.g., 55 solved). For
      reference, CP-SAT solved 115 instances.

    - On 247 COP instances: CP-SAT solved 98 instances, while the
      performance of the other methods was closely clustered: MDD and 
      the min-domain MDD-DOM variant solved 75, the hybrid approach 74,
      the standard integer formulation 73, and the Boolean formulation
      71.

Comments for authors (including questions for rebuttal)
-------------------------------------------------------
This paper provides an in-depth exploration of table constraint
modeling within ILP, which remains a significant topic in the
field. Although the technical content is dense and may be challenging
for readers not specialized in both CP and ILP, the paper is
well-written and benefits from numerous helpful examples. While the
experimental gains for the hybrid approach are less pronounced on COP
instances, the results for CSP instances are promising and show that
the method can compete with MDD-based approaches. Overall, this
research is a valuable contribution.

Main remark:

The number of instances solved seems sensitive to the overhead
associated with model encoding and data structure management. I
believe it is crucial to supplement the current results with
performance profiles showing the number of instances solved over
time. For instance, if a specific approach starts slowly but
eventually overtakes another as time progresses, it would demonstrate
that the encoding overhead is justified for more difficult instances.


Questions:

    - Justification for cut generation: Section 4 notes that while
      linear table formulations are linear in size, they can still
      become prohibitively large, thus justifying lazy cut
      generation. I agree with this assessment. However, I wonder if
      the density of the tables (i.e., the ratio of allowed tuples to
      the Cartesian product of domains) influences the effectiveness
      of this argument? Are cuts more valuable for very sparse or very
      dense tables?

    - MDD-DOM: Is this "min-domain" MDD variant an original contribution
       of this paper, or has it been described previously (e.g., in [6])?

    - POST status: Does the "POST" metric in the tables correspond to
      the number of instances successfully encoded within the
      10-minute timeout?

      It would also be interesting to see statistics on encoding time
      relative to the initial instance size.
      

Technical details:

    Line 79, Equation (1b): Should x be corrected to xi?

    Algorithm 2: This should ideally be placed near Line 328 for better flow.

Candidate for best paper
------------------------
1. No



# REBUTTAL

We thank the reviewers for their careful reading and constructive feedback.

Reviewer A points out two papers: Petit and Claus. We weren't aware of Petit, and will add a citation in section 3.2. We saw the 01 table as folklore, and 3.2 was not meant to represent a strong original contribution. But we believe its very interesting to compare it against other approaches, both empirically and theoretically (i.e. theorems 4, 7). The work of Claus seems quite orthogonal to our contribution.

Indeed, Gurobi's preprocessing is critically important for improving MIP solving; it actually disadvantages the cut generation since it requires enabling the `LazyConstraints` parameter, which turns off some preprocessing. Additionally, we had to adjust (for all approaches) the `MipGap` and `MipGapAbs` parameters to prevent an incorrect optimality status for sub-optimal objectives for a few XCSP3 instances with large coefficient objectives. All other parameters were left as default. We will mention this explicitly.

Both Reviewers A and C offer ideas for more sophisticated table metrics (e.g. density) to improve the hybridization. Our main objective was to answer the third research question on whether the eager and lazy approaches were complementary, and if so, find at least one way to effectively combine approaches. After trying some high-level metrics (e.g. also using the area of the (binary) table), we found that the number of rows showed some standard statistical correlation (i.e. Pearson coefficient) with improvements in solve time for `All` over `MDD-Dom`. When we saw a consistent increase in the number of feasible CSP/COP results with the `Hybrid` approach using this threshold, we felt that the third research question was affirmatively answered. There is indeed still room for a deeper study on appropriate metrics and hybredisation methods, for example, if we could approximate expected MDD size.

Indeed, the paper is purely about positive tables, which are the most fundamental type of table, and also occur often enough by themselves to be of practical interest (e.g. they occur in roughly 25% of the considered XCSP3 competition benchmarks). We will emphasize this more clearly in the introduction. The discussion of other types of tables (e.g. negative, reified, short/smart) will be a natural extension of the techniques in the current paper.

For negative tables each row is a separate constraint and are thus easy to linearise with the Bool encoding (as Petit shows). There is no cut generation required, although one could use lazy constraints to implement them.

For half reified tables we can simply add the reification variable as an indicator to each encoding constraint or use big-M methods to simulate this. Cut generation simply would delay until the reification variable is set, and add it to the cut we currently generate (as indicator or using big-M).

Full reification requires further work to tackle efficiently. Compact and short tables we already briefly discuss.


We actually did create performance profiles (namely cactus plots), but they were not included for space reasons as the table allows us to show additional dimensions like POST/constraints/etc. We will add these to the Appendix to supplement the table. On the particular point, from the table one can already see that the pure lazy approach is able to `POST` additional instances, but is still often overtaken by eager approaches during solve time. We will better clarify in the table caption that `POST` indeed means the full pipeline before we initiate the `solve` call, meaning it consists of reading, encoding, and posting the instance.

On the `MDD-dom` ordering, [6] only considers input order (and discusses how in general, it is NP-hard to find an ordering which minimizes the size of the MDD). While much work exists on BDD variable orderings, we have not seen this min-domain variant described for MDDs, though it is a well-known variable ordering in CP. As mentioned in footnote on page 8, we tried out several other more complex column orderings, some of which were competitive to `MDD-dom`, but we limited our discussion for simplicity.

The initial XCSP3 instance size is hard to specify, as a single constraint may result in a single linear constraint, or tens of thousands. We could compare with the `constraints` column, but note that it is averaged over only the instances which were encoded by all approaches (to remove a bias which would otherwise render this number incomparable accross approaches). Nonetheless, one can clearly see, for instance, that `Int` posts far fewer constraints than `Bool`, and thus is able to post more instances.

We will fix the technical details mentioned by reviewer C.


## old comments

- Wout: to address the point on reification of table constraints, maybe mention how it generalizes (non-valid paths go to a 'false' sink node)
  - Henk: I think I have this already? The important part is to give them the idea our work can be (promisingly) extended to this, but that it's justifiably out of scope for this version

~~Reviewer B indeed says the hybrid to be an unsurprising winner, with which we agree, although there remains unexplored nuance in that it does not help as much for proving optimality.~~
- Henk: just trying to somehow acknowledge this "non-review", will very probably omit

Note the results (POST) show that tables become large enough in some benchmarks they can't be practically encoded, and the BOOL and MDD encodings inhibit this further. 
Cut generation should be expected to be most effective for sparse tables, since we can cut away many non-solutions with one cut.
In practice tables are usually very sparse, so this fits well.
- Henk: I've covered this ; 





We think the summary of Reviewer C is accurate, although we would like to say that the MDD approach is also meant as a novel contribution.
- omitted

- PJS: can we use CpmPy to generate a "all globals" encoding where nothing is decomposed, and use that to define size?
  - Henk: I'm not sure what this would show?


- Wout: TODO maybe address density of tables in more detail? (reviewer 3 also addresses this). Maybe only if there are any interesting insights from (unincluded) experiments
  - Henk: I will see if I have time to analyze an additional metric
  - Henk: on purpose, I'm limiting the discussion/conjecture (e.g. sparse table = good for cut generation) a bit on the additional metrics (to avoid the reviewer concluding the hybrid is incomplete/superficial). I just want to say we answered the question that eager/lazy are complementary and that there is at least one good way (i.e. number of rows) to exploit this, leaving more complicated metrics for future work.





[[remove the following para]]
As to encoding negative or reified tables: each row in a negative table is a separate constraint, 
With regards to MDDs, the construction algorithm by [6] supports both positive and negative tables.
For half-reification, we add a new start node with edge b = 1 to the original start node, and b = 0 to an MDD which allows all solutions (this MDD is not too large).
Cut generation for negative tables is relatively trivial, we could just treat each row as a lazy constraint.
Half-reification for positive/negative tables should be straightforward by generating reified cuts as indicator constraints when a table is both violated and activated.
Full reification requires further work to tackle efficiently.
We looked briefly at short/smart tables, however, this looked non-trivial, especially for cut generation, so we leave it to future work.
We will try to expand our discussion of this somewhat in the paper.

replace ; the modifications to the cut generation were not straightforward so we leave it for future work.