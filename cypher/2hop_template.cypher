// =============================================================
// 2-hop parameterised Cypher template
// =============================================================
//
// Triggered when the question NER step extracts two or more
// entities. Returns paths of length 2 connecting any pair of
// linked entities through an intermediate node, which surfaces
// chains like Metformin -treats-> T2DM -comorbidWith-> CKD.
//
// Parameters:
//   $cuis : list of UMLS CUIs extracted from the question
//   $rels : list of allowed relation types from the 13-relation
//           schema
//
// Notes:
//   - We require the start and end nodes to be DIFFERENT linked
//     entities (n1.cui <> n2.cui) so we don't trivially return
//     two-hop loops back to the starting concept.
//   - We allow the intermediate node to be ANY entity — it does
//     NOT have to be in $cuis. This is what enables the system
//     to find bridge concepts the question did not explicitly
//     name (e.g., Renal Failure as a bridge between Metformin
//     and CKD).
// =============================================================

MATCH p = (n1:Entity)-[r1]->(intermediate:Entity)-[r2]->(n2:Entity)
WHERE n1.cui IN $cuis
  AND n2.cui IN $cuis
  AND n1.cui <> n2.cui
  AND type(r1) IN $rels
  AND type(r2) IN $rels
RETURN n1.label AS start_label,
       n1.cui   AS start_cui,
       type(r1) AS rel1,
       intermediate.label AS bridge_label,
       intermediate.cui   AS bridge_cui,
       type(r2) AS rel2,
       n2.label AS end_label,
       n2.cui   AS end_cui,
       r1.source AS rel1_source,
       r2.source AS rel2_source
LIMIT 50
