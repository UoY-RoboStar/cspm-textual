package robostar.ui

import org.eclipse.xtext.ui.editor.autoedit.DefaultAutoEditStrategyProvider
import org.eclipse.xtext.ui.editor.autoedit.AbstractEditStrategyProvider.IEditStrategyAcceptor
import org.eclipse.jface.text.IDocument

class CSPMDefaultAutoEditStrategyProvider extends DefaultAutoEditStrategyProvider {
	
	override protected configureCompoundBracesBlocks(IEditStrategyAcceptor acceptor) {
		acceptor.accept(compoundMultiLineTerminals.newInstanceFor("{", "}").and("(", ")"), IDocument.DEFAULT_CONTENT_TYPE);
	}
	
}