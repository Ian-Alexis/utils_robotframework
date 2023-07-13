from playwright.async_api import async_playwright
import utils as utils
import asyncio

url = "https://anyway.qal.covage.com"

class connectAnyway():
    async def __init__(self) -> None:
        self.playwright = await async_playwright().start()
        self.browser = await self.playwright.chromium.launch(headless=False)
        self.context = await self.browser.new_context()
        self.page = await self.context.new_page()
        await self.page.goto(url)
        
    async def debug(self):
        await self.context.tracing.start(screenshots=True, snapshots=True, sources=True)

        # Nous devons aussi convertir le sleep en version asynchrone
        await asyncio.sleep(3)

class constructeurClass(connectAnyway):
    async def init(self, test) -> None:
        self.page = self.page
        data = utils.extract_from_json("constructeurs")  # Assurez-vous que cette méthode est aussi asynchrone si nécessaire
        await self.page.get_by_role("link", name=" Constructeurs").click()
        self.nom = data[test]["Nom"]
        self.préfixe_mac = data[test]["Préfixe MAC"]

# Pour utiliser ces classes, vous devez maintenant les initialiser dans un contexte asynchrone.
# Par exemple, vous pouvez créer une coroutine pour votre test :

async def test(): 
    AW = await connectAnyway()
    const_num_1_bis = await constructeurClass()
    await const_num_1_bis.init("Constructeur numéro 1 Bis")
    return True

# Et ensuite lancer cette coroutine avec la boucle d'événements asyncio

asyncio.run(test())
