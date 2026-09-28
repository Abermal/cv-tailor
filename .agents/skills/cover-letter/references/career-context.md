# Career Context

This file contains user-provided context for writing cover letters. It complements, but does not replace, `cv/master_cv.tex`. Use the parent `SKILL.md` for structure and voice; select the background below according to its relevance to the role.

## General technical and domain motivation

- The candidate is broadly motivated by applying machine learning and computer vision to real-world problems and by developing systems that work reliably beyond a research prototype.
- For engineering-heavy roles, the candidate is particularly motivated by mature, reliable systems where maintainability, reproducibility, and a smooth development and operations workflow are treated as core engineering outcomes. The candidate sees this level of technical maturity as an important professional standard to pursue throughout their career.
- The candidate also values meaningful ownership, the ability to move work forward quickly, and a direct, lively working environment. These are possible motivations to select when supported by the advertised work, not preferences to attribute automatically to every startup role.
- Connect a relevant motivation to something specific about the position. "Real-world ML" alone does not distinguish one vacancy from another.
- A meaningful domain can deepen the motivation. Medicine and climate-related work are especially inspiring to the candidate. Mention this briefly and in ordinary language when relevant; do not manufacture mission rhetoric or make every employer sound purpose-driven.

## Medical-imaging trajectory

- Medical imaging has been a recurring field since the candidate's first university projects: CT imaging, then X-ray work, and later cellular imaging. For relevant roles, this can show breadth across modalities and lasting interest. Use a brief trajectory when it strengthens the argument, rather than recounting every project. The relevant experience spans multiple roles and studies; do not reduce it to "my three years."
- The candidate's first substantial projects during their studies were carried out in cooperation with a local hospital. Working with real doctors was highly motivating and established a long-term interest in clinically useful machine learning.
- The thesis focused on machine learning for orthopedics, especially anatomical landmark localization. The work improved the previous model by 30% and involved collaboration with clinical specialists in spine care. It was presented at DWG 2023.
- The candidate then continued in medical imaging through the three-year BMBF Photiomics project. They completed the work successfully despite not having a prior background in cellular science.
- The 2D/3D registration system for implant pose estimation was developed, validated, and deployed almost completely by the candidate. It was presented at EFORT 2026 and is used at scale in current clinical trials.
- For clinically focused roles, connect the motivation to real collaboration with clinicians, validation, and use of the systems. For research-focused work, experimentation and learning across disciplines may be stronger evidence; for engineering-focused work, the system design and deployment context below may matter more. Select relevant examples rather than treating this trajectory as a mandatory project list.

## X-ray modality expertise

- The candidate has broad professional experience with X-ray image analysis, including classification, instance segmentation, object detection, anatomical landmark localization, and 2D/3D registration for implant pose estimation.
- Through this work, the candidate has developed a deep practical understanding of the X-ray modality and its associated image-analysis challenges. For relevant roles, convey this breadth through concrete examples rather than mentioning only the registration pipeline or presenting a generic computer-vision background.
- The 2D/3D registration project required implementing a renderer that simulates X-ray images. The candidate describes this as work undertaken within the project ("we implemented"); do not imply sole authorship of the renderer.
- Developing the X-ray simulation for registration gave the candidate familiarity with the graphics, geometry, and physical principles behind X-ray image formation. Use this as a concrete example of understanding how the images are formed, alongside experience analyzing them. Do not invent specific rendering algorithms, physical models, or implementation details.
- This expertise comes from medical X-ray work. It is relevant transferable experience for industrial X-ray inspection, but does not establish prior industrial defect-detection experience.

## Engineering maturity of the 2D/3D project

- For engineering-focused roles, emphasize that an earlier implementation had become unreliable and unusable after years of incremental changes. The candidate designed and built a mature, modular, maintainable replacement.
- The system included the full CI/CD cycle, a scalable containerized application, and close cooperation with hardware specialists.
- The candidate designed hardware specifications for a local multi-GPU production server because compliance requirements ruled out a cloud deployment.

## Lung-CT project and public communication

- The semantic segmentation model for automated tissue-density analysis of 3D lung CT scans has an [English project video](https://www.youtube.com/watch?v=Xa7rivGy6WQ).
- Use this as supporting evidence of applied medical-AI communication when useful. It is generally better suited to a CV hyperlink or portfolio than to the body of a cover letter, unless public communication is directly relevant to the role.

## Object detection and data-centric model development

- For clinical-trial spine imaging, the candidate developed an object-detection model for anatomical structures. Because the labeled dataset was small, they designed a custom ViTDet architecture with a DINOv3 backbone using MMDetection, trained it with self-supervised learning on a much larger unlabeled dataset, and then performed supervised fine-tuning.
- The candidate designed augmentations to address imbalances in object location, size, and distribution while preserving anatomical constraints.
- Prior to the custom ViTDet work, the candidate worked extensively on a legacy Mask R-CNN detector. This is hands-on experience with an established two-stage detection architecture.
- The candidate proposed replacing the existing COCO annotation tool with CVAT, labeled data personally, and mentored an intern on using the tooling within the intern's project. This supports claims about annotation ownership, labeling quality, and feedback between model errors and dataset revisions.

## Real-time perception and tracking context

- In a freelance role, the candidate developed depth-map-based camera obstruction detection for a real-time retail anti-theft system.
- This work provided experience with real-time inference and event-driven systems using publish-subscribe messaging.
- Through the freelance role and specialized studies, the candidate deepened their understanding of modern detection and tracking methods, including DETR and SORT-based approaches. Present these as studied or familiar methods unless a more specific hands-on implementation is confirmed; do not imply production tracking experience.

## Mission context

- For defence roles: As a Ukrainian citizen, the candidate knows personally what defending democracy means. The opportunity to contribute directly to that cause would be deeply meaningful. Use this plainly and preferably after the technical fit has been established.

## German and stakeholder communication

- Use this evidence when a vacancy explicitly emphasizes German proficiency, stakeholder communication, presentations, knowledge transfer, or explaining complex technical subjects. Do not add it automatically to every letter.
- As of August 2026, the candidate has studied German since age twelve, has lived in Germany for seven years, holds C1 German with a passed TestDaF, and uses German professionally and socially.
- The candidate provided the following reusable German paragraph. It may be shortened or adapted to the vacancy while preserving its factual meaning:

> Deutsch lerne ich seit meinem zwölften Lebensjahr und lebe seit sieben Jahren in Deutschland. Deutsch ist nicht meine Muttersprache, doch mit C1-Niveau und bestandenem TestDaF arbeite und kommuniziere ich sicher auf hohem professionellen Niveau. In einem von mir geleiteten BMBF-Projekt verfasste ich Berichte, vermittelte komplexe Forschungsthemen in Präsentationen und diskutierte sie mit Projektpartnern, darunter Ärztinnen und Ärzte der Charité. Auch im täglichen Austausch mit deutschen Kolleg:innen und Freund:innen ist Deutsch für mich seit Jahren selbstverständlich.

## MRI and volumetric imaging context

- The candidate has wanted to gain hands-on experience with MRI for a long time and is interested in its modality-specific challenges, including sequence-dependent appearance, variable contrast, motion, and real-time constraints.
- The candidate has worked with anisotropic 3D light-sheet microscopy data. This provides transferable experience with voxel-based volumetric data, differences in spatial resolution, and 3D image processing, but does not establish MRI expertise. MRI-specific physics and artifacts would require learning; mention this boundary only when needed to avoid a misleading equivalence.
