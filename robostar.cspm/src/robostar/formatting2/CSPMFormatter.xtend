/*
 * generated by Xtext 2.25.0
 */
package robostar.formatting2

import com.google.inject.Inject
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument
import robostar.cspm.CSPM
import robostar.cspm.RefinementAssertion
import robostar.services.CSPMGrammarAccess

class CSPMFormatter extends AbstractFormatter2 {
	
	@Inject extension CSPMGrammarAccess

	def dispatch void format(CSPM cSPM, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		for (definition : cSPM.definitions) {
			definition.prepend[noIndentation].prepend[noSpace]
			definition.format
			definition.append[noIndentation].append[noSpace]
			//definition.append[newLine]
		}
	}

	def dispatch void format(RefinementAssertion refinementAssertion, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		refinementAssertion.spec.format
		refinementAssertion.implementation.format
	}
	
	// TODO: implement for DeadlockAssertion, DivergenceAssertion, DeterminismAssertion, HasTraceAssertion, TimedSection, ChannelList, DataType, SubTyoe, NameType, Constructor, Module, ModuleInstance, PrintStatement, Function, ConcatPattern, DotPattern, ListPattern, ParenthesesPattern, Set, TuplePattern, ProjectExp, RenameExp, ConcatExp, ListLengthExp, MultExp, DivExp, ModExp, PlusExp, MinusExp, LessThanOrEqualExp, LessThanExp, GreaterThanOrEqualExp, EqualsExp, NotEqualsExp, GreaterThanExp, NotExp, AndExp, OrExp, ColonExp, DotExp, InputExp, OutputExp, NondeterministicInput, Prefix, GuardedExpression, SequentialComposition, SlidingChoice, Interrupt, SynchronisingInterrupt, ExternalChoice, SynchronisingExternalChoice, InternalChoice, Exception, GeneralisedParallel, AlphabetisedParallel, LinkedParallel, Link, Interleave, Hide, DoublePatternExp, ParExp, TupleExp, LambdaExp, MapExp, UnaryNotExp, SetDiff, SetlInter, SetMember, SetLUnion, SequenceElem, Map, FailureWatchdog, Prioritise, PrioritiseNoCache, PrioritisePo, TraceWatchdog, SingleArgFunction, RenamingPair, ListExp, RangedListExp, SetExp, RangedSetExp, EnumeratedSetExp, Mapping, PRef, LetExp, Expression, ReplicatedAlphabetisedParallel, ReplicatedExternalChoice, ReplicatedGeneralisedPrallel, ReplicatedInterleave, ReplicatedInternalChoice, ReplicatedLinkedParallel, ReplicatedSequentialComposition, ReplicatedSynchronisingParallel, PredicateStatement, GeneratorStatement, SetGeneratorStatement, TypeAnnotation, Constraint, DotType, DotableType, ExtendableType, FunctionType, SetType, MapType, SequenceType, TupleType
}
