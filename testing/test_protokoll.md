# Testprotokoll

| Testfall                          | Datum      | Zeit  | Tester         | Ergebniss                                                                                                                                                                                      | Test erfolgreich |
|-----------------------------------|------------|-------|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| App starten                       | 18.03.2024 | 11:00 | Marco Odermatt | App startet wie erwartet und Anmeldeseite wird angezeigt.                                                                                                                                      | ja               |
| Namen definieren und Quiz starten | 18.03.2024 | 11:05 | Marco Odermatt | Der Name konnte erfolgreich definiert werden und man landet auf der Quiz view.                                                                                                                 | ja               |
| Kategorien filtern                | 18.03.2024 | 11:07 | Marco Odermatt | Die ausgewählten Kategorien wurden erfolgreich angewendet und es werden nur noch Fragen zu den ausgewählten Kategorien angezeigt.                                                              | ja               |
| Schwierigkeiten filtern           | 18.03.2024 | 11:12 | Marco Odermatt | Die ausgewählten Schwierigkeiten wurden erfolgreich angewendet und es werden nur noch Fragen zu den ausgewählten Schwierigkeiten angezeigt.                                                    | ja               |
| Punkte sammeln                    | 18.03.2024 | 11:17 | Marco Odermatt | Die ausgewählte Antwort, welche die korrekte Antwort auf die Frage ist hat nun einen grünen Hintergrund. Der Punktestand hat sich um 10 erhöht und nach 2 Sekunden ist die neue Frage geladen. | ja               |
| Ausloggen                         | 18.03.2024 | 11:21 | Marco Odermatt | Man landet auf der Anfangsseite des Apps und muss einen neuen Namen eingeben, um wieder zu starten.                                                                                            | ja               |
| Frage überspringen                | 18.03.2024 | 11:25 | Marco Odermatt | Eine neue Frage wird nun angezeit. Der Punktestand vekleinert sich um 5 Punkte.                                                                                                                | ja (abgeändert)  |
| Reaktionsspiel spielen            | 18.03.2024 | 11:29 | Marco Odermatt | Nach 5 Fragen wurde man auf die Reaction view weitergeleitet und nach 500ms wurde das Device geschüttelt. Der Punktestand hat sich um 20 Punkte erhöht.                                        | ja               |
| Quiz spielen (Punkte verlieren)   | 18.03.2024 | 11:40 | Marco Odermatt | Die ausgewählte Antwort, welche eine unkorrekte Antwort auf die Frage ist hat nun einen roten Hintergrund. Der Punktestand hat sich um 5 Punkte verkleinert.                                   | ja               |

# Note

Beim Test `Frage überspringen` wurde im Testkonzept festgelegt, dass das erwartete Ergebniss `Eine neue Frage wird nun angezeigt.` ist. Jedoch wurde die funktionalität des `Skip` button so angepasst, dass nun auch 5 Punkte abgezogen werden.

# Link zum Testkonzept

[Hier](test_konzept.pdf) ist das Testkonzept zu finden.