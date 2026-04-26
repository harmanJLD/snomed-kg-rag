# KG Schema

The clinical knowledge graph uses a fixed schema of **6 entity types**
and **13 curated relation types**. Every entity is identified by a UMLS
Concept Unique Identifier (CUI) and typed by a SNOMED CT semantic
category. We chose a fixed (rather than open / LLM-generated) schema so
that the Cypher template at query time can be specialised to these edge
types.

## Entity types (6)

| Type | SNOMED CT semantic category | Example CUI | Example label |
|---|---|---|---|
| Disease | Disease, Disorder | C0011860 | Type 2 Diabetes |
| Medication | Pharmacologic Substance | C0025598 | Metformin |
| Symptom | Sign or Symptom | C0027497 | Nausea |
| Lab Test | Laboratory Procedure | C0019018 | HbA1c |
| Procedure | Therapeutic Procedure | C0021107 | Insulin therapy |
| Guideline | Health Care Activity | (source-tagged) | ADA Guidelines 2024 |

## Relation types (13)

| # | Relation | Domain → Range | Description |
|---|---|---|---|
| 1 | `treats` | Medication → Disease | Therapeutic indication of a medication for a disease |
| 2 | `causes` | Disease → Disease/Symptom | Causal relationship between conditions |
| 3 | `contraindicatedWith` | Medication → Disease | Medication should not be used in this condition |
| 4 | `diagnosedBy` | Lab Test → Disease | Test used to diagnose a condition |
| 5 | `hasSideEffect` | Medication → Symptom | Known adverse effect of a medication |
| 6 | `interactsWith` | Medication → Medication | Drug-drug interaction |
| 7 | `indicatedFor` | Procedure → Disease | Procedure indicated for a condition |
| 8 | `partOf` | Disease → Disease | Hierarchical containment (subtype, sub-condition) |
| 9 | `findingSite` | Disease → Anatomy | Anatomical location of a finding |
| 10 | `hasRiskFactor` | Disease → Disease/Condition | Risk factor for a condition |
| 11 | `monitoredBy` | Lab Test → Disease | Lab test used to monitor a condition |
| 12 | `comorbidWith` | Disease → Disease | Co-occurring condition |
| 13 | `recommends` | Guideline → Medication/Procedure | Guideline recommendation (used for both guideline-to-medication and guideline-to-procedure edges) |

## Provenance

Each edge stores a `source` property indicating where it was extracted from:

- `SNOMED_CT` — derived from SNOMED CT relationships
- `ICD-10` — derived from ICD-10 hierarchies
- `EHR_template` — derived from de-identified EHR schema templates
  (see paper §3.2 for what this means)
- `ADA_2024`, `WHO_2023`, `CDC_2024`, `AHA_2023` — derived from named
  public clinical guideline documents

## Schema rationale

The schema is deliberately small. Relations not in the schema (temporal
relations like `precedes` / `follows`, dose-response or
dose-dependent contraindications, drug-drug interaction severity
grading, patient-attribute-conditioned edges such as age or pregnancy
status) are explicitly out of scope for this version. Questions whose
answer hinges on any of these relations gain nothing from the KG path
in the current system. See paper §5 (Limitations) for discussion.
