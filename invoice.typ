#import "tablex.typ": gridx, hlinex

#set text(lang: "de", region: "DE")

#let details = toml("invoice.toml")

#set page(
  paper: "a4",
  margin: (x: 20%, y: 20%, top: 20%, bottom: 20%),
)

// Typst can't format numbers yet, so we use this from here:
// https://github.com/typst/typst/issues/180#issuecomment-1484069775
#let format_currency(number) = {
  let precision = 2
  assert(precision>0)
  let s = str(calc.round(number, digits: precision))
  let after_dot = s.find(regex("\..*"))
  if after_dot==none {
    s=s+"."
    after_dot="."
  }
  for i in range(precision - after_dot.len()+1){
    s=s+"0"
  }
  // fake de locale
  s.replace(".", ",")
}

#set text(number-type: "old-style")

#smallcaps[
  *#details.author.name* •
  #details.author.street •
  #details.author.zip #details.author.city
]

#v(1em)

#[
  #set par(leading: 0.40em)
  #set text(size: 1.2em)
  #details.recipient.name \
  #details.recipient.street \
  #details.recipient.zip
  #details.recipient.city
]

#v(4em)

#[
  #set align(right)
  #details.author.city, #details.date
]

#heading[
  Rechnung \##details.invoice-nr
]

#let items = details.items.enumerate().map(
    ((id, item)) => (
      [#str(id + 1).],
      [#item.description],
      [],
      [#format_currency(item.price)€]
    )
  ).flatten()

#let total = details.items.map((item) => item.at("price")).sum()

#[
  #set text(number-type: "lining")
  #gridx(
    columns: (1fr, auto, auto, 1fr),
    align: ((column, row) => if column >= 2 { right } else { left} ),
    hlinex(stroke: (thickness: 0.5pt)),
    [*Pos.*], [*Description*], [], [*Preis*],
    hlinex(),
    ..items,
    hlinex(),
    [], [], [ Summe:], [#format_currency((1.0 - details.vat) * total)€],
    hlinex(start: 3),
    [], [], [
      #set text(number-type: "old-style")
      #str(details.vat * 100)% Mehrwertsteuer:
    ], [#format_currency(details.vat * total)€],
    hlinex(start: 3),
    [], [], [ *Gesamt:* ], [*#format_currency(total)€*],
    hlinex(start: 3),
  )
]

#v(3em)

#[
  #set text(size: 0.8em)
  Vielen Dank für die Zusammenarbeit. Die Rechnungssumme überweisen Sie bitte innerhalb von 14 Tagen ohne Abzug auf mein unten genanntes Konto unter Nennung der
  Rechnungsnummer.

  Gemäß § 19 UStG wird keine Umsatzsteuer berechnet.
]

#v(1em)

#[
  #set par(leading: 0.40em)
  #set text(number-type: "lining")
  #details.bank_account.name \
  Kreditinstitut #details.bank_account.bank \
  IBAN: *#details.bank_account.iban* \
  BIC: #details.bank_account.bic
]

Steuernummer: #details.author.tax_nr

#v(1em)

Mit freundlichen Grüßen,

#v(1em)

#details.author.name
