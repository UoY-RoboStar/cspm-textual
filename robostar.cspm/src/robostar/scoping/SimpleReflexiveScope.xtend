package robostar.scoping

import org.eclipse.xtext.scoping.impl.SimpleScope
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.emf.ecore.EObject
import java.util.ArrayList
import org.eclipse.xtext.resource.EObjectDescription

class SimpleReflexiveScope extends SimpleScope {
	
	EObject localObject
	IEObjectDescription objDesc
	
	new(IScope parent, EObject object) {
		super(parent, new ArrayList<IEObjectDescription>)
		localObject = object
	}

	new(IScope parent, Iterable<IEObjectDescription> descriptions) {
		super(parent, descriptions)
	}
	
	new(IScope parent, Iterable<IEObjectDescription> descriptions, boolean ignoreCase) {
		super(parent, descriptions, ignoreCase)
	}
	
	override protected getLocalElementsByName(QualifiedName name) {
		if (localObject !== null) {
			objDesc = EObjectDescription.create(name,localObject)
			var listobjs = new ArrayList<IEObjectDescription>
			listobjs.add(objDesc)
			return listobjs
		} else {
			super.getLocalElementsByName(name)
		}
	}
	
}