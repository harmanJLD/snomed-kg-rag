// =============================================================
// 1-hop parameterised Cypher template
// =============================================================
//
// This is the core retrieval query used on the KG path of the
// dual-path retriever (see paper §3.3 and Listing 1).
//
// Parameters:
//   $cuis : list of UMLS CUIs extracted from the question by
//           SciSpacy + UMLS entity linking
//   $rels : list of allowed relation types from the 13-relation
//           schema (see schema/schema.md)
//
// Behaviour:
//   The template matches edges where EITHER endpoint is a linked
//   entity, so triples in which the question entity appears as
//   the object (e.g., guideline-to-medication recommendations
//   such as (ADA_Guideline, recommends, Metformin)) are also
//   retrieved.
//
// Example invocation (Neo4j Browser):
//   :param cuis => ['C0025598','C0011860','C0022661','C0017654']
//   :param rels => ['treats','contraindicatedWith','hasRiskFactor',
//                   'comorbidWith','recommends','monitoredBy',
//                   'diagnosedBy','hasSideEffect','interactsWith',
//                   'indicatedFor','partOf','findingSite','causes']
// =============================================================

MATCH (n:Entity)-[r]->(m:Entity)
WHERE (n.cui IN $cuis OR m.cui IN $cuis)
  AND type(r) IN $rels
RETURN n.label AS subject_label,
       n.cui   AS subject_cui,
       type(r) AS relation,
       m.label AS object_label,
       m.cui   AS object_cui,
       r.source AS source
LIMIT 50
