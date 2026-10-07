"""AQP §9 independent re-derivation, written by the orchestrating context from the stems alone
(not from the authors' verify scripts or rationales). Prints each recomputed key value."""
NA = 6.022e23
r = {}
def ratio(a, ma, b, mb): return (b / mb) / (a / ma)
r['f1-v1 N:Si'] = ratio(60.06, 28.09, 39.94, 14.01)            # 1.333 -> Si3N4
r['f1-v2 C:Al'] = ratio(3.238, 26.98, 1.081, 12.01)            # 0.750 -> Al4C3
r['f1-v3 O:Ga'] = ratio(2.789, 69.72, 0.955, 16.00)            # ~1.49 -> Ga2O3
r['f2-v1 %Ge GeCl4'] = 100 * 72.63 / (72.63 + 4 * 35.45)       # 33.87
r['f2-v2 %Cl SbCl5'] = 100 * 5 * 35.45 / (121.76 + 5 * 35.45)  # 59.28
r['f2-v3 %H B2H6, M'] = (100 * 6 * 1.008 / (2 * 10.81 + 6 * 1.008), 2 * 10.81 + 6 * 1.008)  # 21.86, 27.67
r['f3-v1 mol O'] = 2.00 * 6                                     # 12.0
r['f3-v2 mol H'] = 0.250 * (2 * 4 + 1)                          # 2.25
r['f3-v3 O atoms'] = 0.120 * 8 * NA                             # 5.78e23
r['f4-v1 cm3'] = 63.55 / 8.96                                   # 7.09
r['f4-v2 molecules'] = 25.0 * 3.10 / 159.8 * NA                 # 2.92e23
r['f4-v3 cm3/atom'] = 196.97 / 19.3 / NA                        # 1.69e-23
r['f5-v1 %'] = 100 * 0.0300 / 2 * 142.04 / 5.00                 # 42.6
r['f5-v2 %'] = 100 * 1.00 / 40.08 * 100.09 / 4.50               # 55.5
r['f5-v3 %'] = 100 * 2.20 / (2 * 63.55) * 159.17 / 8.00         # 34.4
r['f6-v1 M'] = (0.0200 + 2 * 0.0150) / 0.2500                   # 0.200
r['f6-v2 M'] = 3 * 2.55 / 212.27 / 0.2500                       # 0.144
r['f6-v3 M'] = (2 * 2.64 / 132.15 + 0.800 / 80.05) / 0.3500     # 0.143
R, T = 0.08206, 295.15
M_true = 0.520 / ((0.9921 - 0.0261) * 0.2340 / (R * T)); M_err = 0.520 / (0.9921 * 0.2340 / (R * T))
r['f7-v3 M true, M with error'] = (round(M_true, 1), round(M_err, 1))  # error -> too low
r['f8-v1 successive drops'] = (round(24.815 - 24.702, 3), round(24.702 - 24.668, 3))  # not converged
r['f8-v2 % water'] = 100 * (19.870 - 19.353) / (19.870 - 16.420)   # 15.0, last drop 0.002
r['f8-v3 % acetone, last drop'] = (100 * (31.250 + 6.000 - 36.198) / 6.000, round(36.237 - 36.198, 3))  # 17.5, still falling -> too low
for k, v in r.items(): print(f'{k:28s} {v}')
