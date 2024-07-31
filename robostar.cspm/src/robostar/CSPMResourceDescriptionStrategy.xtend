package robostar

import org.eclipse.xtext.resource.impl.DefaultResourceDescriptionStrategy
import com.google.inject.Inject
import org.eclipse.xtext.scoping.impl.ImportUriResolver
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.util.IAcceptor
import org.eclipse.xtext.resource.IEObjectDescription
import robostar.cspm.CSPM
import robostar.cspm.Include
import java.util.HashMap
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.naming.QualifiedName

// Adapted from https://blogs.itemis.com/en/in-five-minutes-to-transitive-imports-within-a-dsl-with-xtext
class CSPMResourceDescriptionStrategy extends DefaultResourceDescriptionStrategy {
	public static final String INCLUDES = "includes"
	@Inject
	ImportUriResolver uriResolver

	override createEObjectDescriptions(EObject eObject, IAcceptor<IEObjectDescription> acceptor) {
		if(eObject instanceof CSPM) {
			this.createEObjectDescriptionForCSPM(eObject, acceptor)
			return true
		}
		else {
			super.createEObjectDescriptions(eObject, acceptor)
		}
	}

	def void createEObjectDescriptionForCSPM(CSPM cspm, IAcceptor<IEObjectDescription> acceptor) {
		val uris = newArrayList()
		cspm.definitions.filter(Include).forEach[uris.add(uriResolver.apply(it))]
		val userData = new HashMap<String,String>
		userData.put(INCLUDES, uris.join(","))
		acceptor.accept(EObjectDescription.create(QualifiedName.create(cspm.eResource.URI.toString), cspm, userData))
	}
}