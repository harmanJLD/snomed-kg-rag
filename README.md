# SNOMED CT-Aligned KG-RAG for Clinical QA

This repository accompanies the KGC 2026 poster paper:

> Harmandeep Kaur. *Ontology-Grounded Knowledge Graphs for Clinical
> LLM Systems: A SNOMED CT-Driven Approach to Retrieval-Augmented
> Generation.* KGC 2026 Poster Track, May 4–8, 2026, New York, NY, USA.

The paper describes a system that combines a SNOMED CT-aligned clinical
knowledge graph (≈45K entities, ≈180K relations) with dense vector
retrieval for clinical question answering, and reports an expert-rated
evaluation on 150 clinical questions showing that ontology-grounded
retrieval improves accuracy, reduces hallucination, and improves
evidence traceability versus a vector-only RAG baseline.

## Contents

```
snomed-kg-rag/
├── README.md                       this file
├── LICENSE                         MIT for code, CC BY 4.0 for data
├── schema/
│   ├── schema.md                   13 relations, 6 entity types, descriptions
│   └── schema.json                 machine-readable schema
├── sample_triples/
│   └── sample_triples.tsv          ~50 illustrative triples
├── cypher/
│   ├── 1hop_template.cypher        the parameterised 1-hop query
│   └── 2hop_template.cypher        the 2-hop extension
├── evaluation/
│   ├── questions.csv               150 questions + reference answers
│   ├── ratings.csv                 expert ratings per question/system
│   ├── per_category_summary.csv    aggregated per-category numbers
│   └── model_outputs/              raw LLM responses per system × backend
└── paper/
    └── Paper2_final.pdf            final published paper (added on publication)
```

## Notes on what is and is not released

- **Schema, Cypher templates, sample triples**: fully released here.
- **150-question evaluation set, expert ratings, aggregated metrics**:
  released here.
- **Raw model outputs**: released as JSONL with one line per question
  in `evaluation/model_outputs/`.
- **Raw EHR-derived note templates**: NOT released; they encode internal
  site-specific field naming and are not redistributable. The experiments
  used schema-level field definitions only, with no patient-identifiable
  data and no individual record content.
- **Full SNOMED CT concept descriptions**: NOT redistributed. SNOMED CT
  requires a UMLS license to redistribute concept content beyond
  identifiers; we therefore include CUIs and concept IDs only. To map
  CUIs back to descriptions, see <https://uts.nlm.nih.gov/uts/umls>.

## Quick start

To replicate the KG path in your own Neo4j instance:

1. Load the sample triples from `sample_triples/sample_triples.tsv`
   into Neo4j as `(:Entity {cui, label})-[r {source}]->(:Entity)`.
2. Open `cypher/1hop_template.cypher` and replace `$cuis` with a list
   of UMLS CUIs from your question (e.g., the four CUIs in the
   worked example: C0025598, C0011860, C0022661, C0017654).
3. Replace `$rels` with the 13 relation names listed in `schema/schema.md`.
4. Run the query in Neo4j Browser. You should see triples connected
   to the input CUIs returned with provenance tags.

## Citation

If you use this material, please cite:

```bibtex
@inproceedings{kaur2026snomedkgrag,
  title     = {Ontology-Grounded Knowledge Graphs for Clinical LLM Systems:
               A SNOMED CT-Driven Approach to Retrieval-Augmented Generation},
  author    = {Kaur, Harmandeep},
  booktitle = {Proceedings of the Knowledge Graph Conference (KGC 2026),
               Poster Track},
  year      = {2026},
  address   = {New York, NY, USA}
}
```

## License

- **Code** (Cypher templates, scripts): MIT License — see `LICENSE`.
- **Data** (questions, ratings, sample triples, model outputs):
  Creative Commons Attribution 4.0 International (CC BY 4.0).

## Contact

Harmandeep Kaur — `harmandeep.kaur@uconn.edu`
Department of Computer Science & Engineering, University of Connecticut.
