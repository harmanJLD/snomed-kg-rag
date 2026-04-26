# Model Outputs

This folder contains the raw responses of every system × model combination
on every question in the evaluation set. Each file is JSON Lines (JSONL):
one JSON object per question, one file per (system, model) pair.

## Files

| File | System | Model | Lines |
|---|---|---|---|
| `gpt4_llm_only.jsonl` | LLM-only (no retrieval) | GPT-4 (gpt-4-0613) | 150 |
| `gpt4_standard_rag.jsonl` | Standard RAG (PubMedBERT + FAISS) | GPT-4 | 150 |
| `gpt4_kg_rag.jsonl` | KG-RAG (dual-path) | GPT-4 | 150 |
| `llama3_llm_only.jsonl` | LLM-only | Llama-3-8B-Instruct | 150 |
| `llama3_standard_rag.jsonl` | Standard RAG | Llama-3-8B-Instruct | 150 |
| `llama3_kg_rag.jsonl` | KG-RAG | Llama-3-8B-Instruct | 150 |

## Schema (one line per question)

```json
{
  "question_id": "Q001",
  "system": "kg_rag",
  "model": "gpt4",
  "model_version": "gpt-4-0613",
  "temperature": 0.2,
  "retrieved_kg_triples": [
    ["Metformin", "treats", "Type 2 Diabetes", "C0025598", "C0011860", "ADA_2024"]
  ],
  "retrieved_passages": [
    {"text": "...", "source": "...", "score": 0.87}
  ],
  "prompt": "answer the clinical question and cite sources where possible. Question: ...",
  "response": "Metformin is the ADA-recommended first-line agent ...",
  "cited_sources": ["SNOMED:44054006", "ADA_2024", "SNOMED:91273001"],
  "latency_ms": 1842
}
```

For LLM-only runs, `retrieved_kg_triples` and `retrieved_passages` are
empty lists. For Standard RAG, `retrieved_kg_triples` is empty.

## Status

These files are placeholders pending release of the experimental run
artifacts. Q001 is provided as a worked example matching paper §3.4.
