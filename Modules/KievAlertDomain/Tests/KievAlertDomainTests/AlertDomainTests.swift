import Testing
import KievAlertDomain

struct AlertDomainTests {
    @Test
    func kyivCityRegion_isStable() {
        #expect(AlertRegion.kyivCity == AlertRegion.kyivCity)
    }
}

