# Career Context

This file contains user-provided context for writing cover letters. It complements, but does not replace, `cv/master_cv.tex`.

## Medical-imaging trajectory

- The candidate's first substantial projects during their studies were carried out in cooperation with a local hospital. Working with real doctors was highly motivating and established a long-term interest in clinically useful machine learning.
- The thesis focused on machine learning for orthopedics, especially anatomical landmark localization. The work improved the previous model by 30% and involved collaboration with clinical specialists in spine care. It was presented at DWG 2023.
- The candidate then continued in medical imaging through the three-year BMBF Photiomics project. They completed the work successfully despite not having a prior background in cellular science.
- The 2D/3D registration system for implant pose estimation was developed, validated, and deployed almost completely by the candidate. It was presented at EFORT 2026 and is used at scale in current clinical trials.

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

## Writing guidance

- Present the trajectory differently depending on the position. Research-heavy roles should foreground clinical questions, experimentation, learning across disciplines, and validation. Engineering-heavy roles should foreground maintainability, deployment, infrastructure, compliance constraints, and reliable production use.
- Keep the tone personal but restrained. The goal is to show why the work matters and why the role is a credible next step, not to repeat the CV.
- For a direct opening, the candidate prefers motivation for both the role's technical challenge and the employer's mission, followed by "I believe my experience..." and a clear contribution statement. Do not reduce the candidate's fit to "my three years" because the relevant experience comes from several roles and studies.
- Avoid employer-as-benefit language such as "a strong next step for me." Center what is compelling about the work and what the candidate can contribute.
- Do not volunteer weak-point disclaimers about missing modalities, tracking, or sensor-fusion experience. Describe relevant transferable experience and genuine interest without implying experience that is not present.
- Avoid generic package lists in the letter. Prefer concrete architectures, data decisions, annotation ownership, and deployment constraints tied to specific work.

## MRI and volumetric imaging context

- The candidate has wanted to gain hands-on experience with MRI for a long time and is interested in its modality-specific challenges, including sequence-dependent appearance, variable contrast, motion, and real-time constraints.
- The candidate has worked with anisotropic 3D light-sheet microscopy data. This provides transferable experience with voxel-based volumetric data, differences in spatial resolution, and 3D image processing, but should not be presented as equivalent to MRI expertise. Acknowledge the need to learn MRI-specific physics and artifacts.

## Role-specific selection

- For a medical-imaging research or medtech role such as Nano4Imaging's AI Research Engineer, lead with the early hospital collaborations, the lasting motivation of working on clinically meaningful problems, the orthopedic thesis, the three-year Photiomics project, and the clinically deployed 2D/3D registration work. Mention EFORT 2026 and use of the system in current clinical trials where relevant.
- Do not import the legacy-replacement, backend architecture, hardware-specification, or compliance-deployment story into that kind of letter unless the vacancy explicitly emphasizes those responsibilities.
