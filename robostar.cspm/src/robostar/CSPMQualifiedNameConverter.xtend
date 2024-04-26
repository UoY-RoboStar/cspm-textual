package robostar

import org.eclipse.xtext.naming.IQualifiedNameConverter

class CSPMQualifiedNameConverter extends IQualifiedNameConverter.DefaultImpl {
	
	override getDelimiter() {
		return "::";
	}
	
}