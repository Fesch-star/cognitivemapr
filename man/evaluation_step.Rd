% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/evaluation_step.R
\name{evaluation_step}
\alias{evaluation_step}
\title{Performs one iteration through the CM to determine the (normative) value
of the nodes in the CM}
\usage{
evaluation_step(edgelist, nodelist)
}
\arguments{
\item{edgelist}{an edgelist}

\item{nodelist}{a nodelist, if you want to add the evaluation
to the dataframe with the basic CM measures as calculated above, be
sure to use the 'node_measures' list that was returned when running the
calculate_degrees function.}
}
\value{
Returns a list with the resulting edgelist and nodelist
}
\description{
Helper-function. This function runs a single evaluation step to determine
to what extent the nodes (concepts) in a CM are considered to be positive
(are supported), negative (not supported) or ambiguous (has positive and
negative consequences) as derived from the argumentation in the map.
It determines the evaluation of a node (cause-concept) by analysing its outgoing
relations (consequent paths) taking into account the initial value (positive,
negative, ambiguous) of the nodes in the consequent path (effect-concepts) and
the sign (positive, negative, non-existent) of the relation between the node
(cause-concept) and the nodes in it's consequent paths (effect-concepts). If
a node (cause-concept) is positively linked to a consequent node (effect-concept)
which is valued positively (a contributes positively to b and b is seen as a
positive thing); then logically the node (cause-concept) is also regarded as
positive. A negative relation to a positive consequent node (effect-concept)
(a diminishes b, while b is seen as a positive thing) logically leads to the
conclusion that the node (cause-concept) is valued negatively. A negative
relation to a negatively valued node (effect-concept) suggest that the
cause-concept positive.
The function takes the dyads of nodes (cause and effect-concept) and determines
the value of all cause-concepts. As nodes may have multiple consequent paths,
that may lead to different conclusions as to the value of the cause-concept.
This function only performs this analysis once. It often needs to be iterated a
multiple times in order to return the true value of the concepts in a CM,
because when performing this analysis the value of the concepts may change and
therefore subsequently the value of other concepts will need to change too. To
conduct a more holistic and accurate analysis of the value of the concepts, use
the "evaluate_concepts" function in this R-package.
}
