# -*- coding: utf-8 -*-
# Copyright 2016 Camptocamp SA
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html)

from anthem.lyrics.records import create_or_update


def create_partners(ctx):
    names = [('Khiank Mountaingut', 'partner_1'),
             ('Kher Fernthorn', 'partner_2'),
             ('Sheing Coaldigger', 'partner_3'),
             ]
    for name, xmlid in names:
        create_or_update(ctx, 'res.partner', xmlid, {'name': name})


def main(ctx):
    create_partners(ctx)
