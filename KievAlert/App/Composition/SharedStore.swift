import KievAlertData
import KievAlertStatus
import KievAlertDomain

let sharedProvider = UbillingAirAlertProvider()
let sharedFetchStatusUseCase = FetchAlertStatusUseCase(provider: sharedProvider)


